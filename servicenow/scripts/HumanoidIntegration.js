/**
 * Humanoid Integration Script Include
 * Provides integration functions between ServiceNow and Humanoid robot system
 */

var HumanoidIntegration = Class.create();
HumanoidIntegration.prototype = {
    
    initialize: function() {
        this.apiEndpoint = gs.getProperty('humanoid.api.endpoint', 'https://humanoid-system.local/api');
        this.apiKey = gs.getProperty('humanoid.api.key', '');
        this.timeout = 30000; // 30 seconds
    },
    
    /**
     * Send a command to the Humanoid robot system
     * @param {Object} command - The command object to send
     * @returns {Object} Response from Humanoid system
     */
    sendCommand: function(command) {
        try {
            var request = new sn_ws.RESTMessageV2();
            request.setEndpoint(this.apiEndpoint + '/commands');
            request.setHttpMethod('POST');
            request.setRequestHeader('Content-Type', 'application/json');
            request.setRequestHeader('Authorization', 'Bearer ' + this.apiKey);
            
            // Enhance command with metadata
            var enhancedCommand = {
                command: command,
                timestamp: new GlideDateTime().toString(),
                source: 'servicenow',
                requestId: gs.generateGUID()
            };
            
            request.setRequestBody(JSON.stringify(enhancedCommand));
            
            var response = request.execute();
            var responseBody = response.getBody();
            var statusCode = response.getStatusCode();
            
            if (statusCode >= 200 && statusCode < 300) {
                return JSON.parse(responseBody);
            } else {
                gs.error('Humanoid API error: ' + statusCode + ' - ' + responseBody);
                return {
                    success: false,
                    error: 'API call failed with status ' + statusCode
                };
            }
            
        } catch (error) {
            gs.error('Humanoid integration error: ' + error.toString());
            return {
                success: false,
                error: error.toString()
            };
        }
    },
    
    /**
     * Install software using Humanoid automation
     * @param {String} softwareName - Name of the software to install
     * @param {String} targetSystem - Target system for installation
     * @param {String} version - Software version (optional)
     * @returns {Object} Installation task response
     */
    installSoftware: function(softwareName, targetSystem, version) {
        var command = {
            action: 'install_software',
            software_name: softwareName,
            target_system: targetSystem,
            version: version || 'latest',
            voice_command: 'Install ' + softwareName + ' version ' + (version || 'latest') + ' on ' + targetSystem,
            automation_level: 'full',
            iot_enabled: true,
            google_assistant_integration: true
        };
        
        var response = this.sendCommand(command);
        
        if (response.success) {
            gs.info('Humanoid installation task created: ' + response.task_id);
        } else {
            gs.error('Failed to create Humanoid installation task: ' + response.error);
        }
        
        return response;
    },
    
    /**
     * Check the status of a Humanoid task
     * @param {String} taskId - ID of the task to check
     * @returns {Object} Task status response
     */
    checkTaskStatus: function(taskId) {
        try {
            var request = new sn_ws.RESTMessageV2();
            request.setEndpoint(this.apiEndpoint + '/tasks/' + taskId + '/status');
            request.setHttpMethod('GET');
            request.setRequestHeader('Authorization', 'Bearer ' + this.apiKey);
            
            var response = request.execute();
            var responseBody = response.getBody();
            var statusCode = response.getStatusCode();
            
            if (statusCode >= 200 && statusCode < 300) {
                return JSON.parse(responseBody);
            } else {
                return {
                    success: false,
                    error: 'Failed to get task status: ' + statusCode
                };
            }
            
        } catch (error) {
            gs.error('Error checking Humanoid task status: ' + error.toString());
            return {
                success: false,
                error: error.toString()
            };
        }
    },
    
    /**
     * Send voice command to Google Assistant integration
     * @param {String} command - Voice command to execute
     * @returns {Object} Voice command response
     */
    sendVoiceCommand: function(command) {
        var voiceCommand = {
            action: 'voice_command',
            command: command,
            assistant: 'google_assistant',
            response_required: true
        };
        
        return this.sendCommand(voiceCommand);
    },
    
    /**
     * Control IoT devices through Humanoid system
     * @param {String} deviceType - Type of IoT device
     * @param {String} action - Action to perform on device
     * @param {Object} parameters - Additional parameters
     * @returns {Object} IoT command response
     */
    controlIoTDevice: function(deviceType, action, parameters) {
        var iotCommand = {
            action: 'iot_control',
            device_type: deviceType,
            device_action: action,
            parameters: parameters || {},
            voice_feedback: true
        };
        
        return this.sendCommand(iotCommand);
    },
    
    /**
     * Get system status from Humanoid robot
     * @returns {Object} System status response
     */
    getSystemStatus: function() {
        try {
            var request = new sn_ws.RESTMessageV2();
            request.setEndpoint(this.apiEndpoint + '/status');
            request.setHttpMethod('GET');
            request.setRequestHeader('Authorization', 'Bearer ' + this.apiKey);
            
            var response = request.execute();
            var responseBody = response.getBody();
            var statusCode = response.getStatusCode();
            
            if (statusCode >= 200 && statusCode < 300) {
                return JSON.parse(responseBody);
            } else {
                return {
                    success: false,
                    error: 'Failed to get system status: ' + statusCode
                };
            }
            
        } catch (error) {
            gs.error('Error getting Humanoid system status: ' + error.toString());
            return {
                success: false,
                error: error.toString()
            };
        }
    },
    
    type: 'HumanoidIntegration'
};

/**
 * Global function to check Humanoid installation status
 * Used by scheduled jobs and business rules
 */
function checkHumanoidInstallationStatus(requestId, taskId) {
    var humanoid = new HumanoidIntegration();
    var taskStatus = humanoid.checkTaskStatus(taskId);
    
    if (taskStatus.success) {
        var gr = new GlideRecord('x_custom_software_request');
        if (gr.get(requestId)) {
            gr.installation_status = taskStatus.status;
            gr.installation_progress = taskStatus.progress || 0;
            
            if (taskStatus.status == 'completed') {
                gr.state = 'completed';
                gr.completion_time = new GlideDateTime();
                gs.info('Humanoid installation completed for request: ' + requestId);
            } else if (taskStatus.status == 'failed') {
                gr.state = 'installation_failed';
                gr.installation_error = taskStatus.error || 'Installation failed';
                gs.error('Humanoid installation failed for request: ' + requestId);
            }
            
            gr.update();
            
            // Reschedule check if still in progress
            if (taskStatus.status == 'in_progress' || taskStatus.status == 'pending') {
                var scheduler = new GlideScheduler();
                scheduler.whenNext(300); // Check again in 5 minutes
                scheduler.setName('Check Humanoid Installation Status');
                scheduler.setScript('checkHumanoidInstallationStatus("' + requestId + '", "' + taskId + '")');
            }
        }
    } else {
        gs.error('Failed to check Humanoid task status: ' + taskStatus.error);
    }
}