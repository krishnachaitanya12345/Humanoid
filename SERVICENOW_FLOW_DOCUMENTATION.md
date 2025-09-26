# ServiceNow Non-Standard Software Request Flow

## Overview

This ServiceNow flow automates the processing of non-standard software requests through integration with the Humanoid robot automation system. The flow handles the complete lifecycle from request submission to automated installation using voice commands and IoT integration.

## Flow Architecture

### Core Components

1. **Flow Configuration** (`non_standard_software_request_flow.json`)
   - Defines the complete workflow stages and automation logic
   - Integrates with Humanoid robot system for automated installation
   - Includes error handling and retry mechanisms

2. **Workflow Definition** (`non_standard_software_workflow.xml`)
   - ServiceNow native workflow implementation
   - Contains activity definitions and approval processes
   - Includes JavaScript business logic for each stage

3. **Custom Table** (`software_request_table.xml`)
   - Defines the `x_custom_software_request` table structure
   - Fields for tracking request details and workflow state
   - Integration fields for Humanoid task management

4. **Humanoid Integration** (`HumanoidIntegration.js`)
   - Script Include for Humanoid robot API integration
   - Functions for software installation automation
   - Voice command and IoT device control capabilities

5. **Business Rule** (`business_rule_auto_trigger.xml`)
   - Automatically triggers workflow on request submission
   - Creates activity logs and error handling

## Workflow Stages

### 1. Initial Validation
- **Type**: Automated
- **Duration**: ~30 seconds
- **Actions**:
  - Validates required fields
  - Calculates request priority
  - Sets validation status
- **Outcomes**: `passed` → Manager Approval, `failed` → Validation Failed

### 2. Manager Approval
- **Type**: Human approval
- **Duration**: 72 hours (with escalation)
- **Approver**: Direct manager of requestor
- **Escalation**: Department head after 48 hours
- **Outcomes**: `approved` → Technical Review, `rejected` → Rejected

### 3. Technical Review
- **Type**: Technical team approval
- **Duration**: 48 hours
- **Actions**:
  - Security assessment
  - System compatibility check
  - Technical risk evaluation
- **Outcomes**: `approved` → Installation, `rejected` → Rejected

### 4. Procurement & Installation Preparation
- **Type**: Automated
- **Duration**: ~3 minutes
- **Actions**:
  - Creates procurement tasks
  - Schedules Humanoid installation
  - Notifies Humanoid system
- **Next Stage**: Installation Execution

### 5. Installation Execution
- **Type**: Automated (Humanoid integration)
- **Duration**: Up to 30 minutes
- **Actions**:
  - Executes Humanoid installation command
  - Uses Google Assistant voice commands
  - Performs installation verification
  - Updates CMDB records
- **Integration**: Full Humanoid robot automation with IoT

### 6. Post-Installation Validation
- **Type**: Automated
- **Duration**: ~10 minutes
- **Actions**:
  - Runs post-installation tests
  - Generates installation report
  - Notifies stakeholders
- **Final State**: Completed

## Humanoid Integration Features

### Voice Command Integration
- **Assistant**: Google Assistant
- **Commands**: Natural language installation instructions
- **Example**: "Install Adobe Photoshop version 2023 on workstation WS001"

### IoT Automation
- **Capabilities**: Remote system control
- **Integration**: Electronic appliance automation
- **Scope**: Worldwide access through IoT connectivity

### API Integration
- **Endpoint**: `/api/humanoid/commands`
- **Authentication**: OAuth2
- **Methods**: POST (commands), GET (status)
- **Response Format**: JSON

## Configuration

### System Properties
Configure these ServiceNow system properties:

```
humanoid.api.endpoint = https://your-humanoid-system.local/api
humanoid.api.key = your-oauth2-api-key
humanoid.voice.enabled = true
humanoid.iot.enabled = true
```

### Table Permissions
Ensure proper access controls for the `x_custom_software_request` table:
- **Create**: All authenticated users
- **Read**: Requestors, managers, technical team
- **Update**: System, workflow automation
- **Delete**: Administrators only

### Workflow Activation
1. Import all XML files to ServiceNow instance
2. Activate the "Non-Standard Software Request Workflow"
3. Configure approval groups and users
4. Test with sample non-standard software request

## Usage Instructions

### For End Users
1. Navigate to **Software Requests** → **Create New**
2. Select **Request Type**: "Non-Standard"
3. Fill in required fields:
   - Software Name
   - Vendor
   - Business Justification
   - Target Systems
4. Submit the request
5. Track progress through automated email notifications

### For Administrators
1. Monitor workflow execution in **Workflow Admin**
2. View Humanoid integration logs in **System Logs**
3. Handle exceptions through **Incident Management**
4. Generate reports from **Software Request Analytics**

## Error Handling

### Automatic Retry
- **Retry Attempts**: 3
- **Retry Delay**: 5 minutes
- **Applicable Stages**: All automated stages

### Failure Actions
1. **Create Incident**: High priority incident for support team
2. **Notify Stakeholders**: Email notifications to all relevant parties
3. **Workflow Suspension**: Allows manual intervention

### Common Issues
- **Humanoid API Timeout**: Increase timeout settings
- **Installation Failures**: Check target system connectivity
- **Voice Command Issues**: Verify Google Assistant integration

## Monitoring and Reporting

### Key Metrics
- Request processing time
- Approval duration
- Installation success rate
- Humanoid automation efficiency

### Dashboards
- Real-time workflow status
- Humanoid system health
- Installation success trends
- User satisfaction metrics

## Security Considerations

### Data Protection
- All API communications use HTTPS/TLS
- OAuth2 authentication for Humanoid integration
- Audit logging for all actions

### Access Controls
- Role-based permissions for different user types
- Approval delegation capabilities
- Secure credential storage

### Compliance
- SOX compliance for approval workflows
- ITIL best practices implementation
- Change management integration

## Troubleshooting

### Common Issues and Solutions

#### Workflow Not Starting
- **Cause**: Business rule not active
- **Solution**: Activate "Non-Standard Software Request Auto-Trigger" rule

#### Humanoid Integration Failure
- **Cause**: API endpoint unavailable
- **Solution**: Check network connectivity and API key validity

#### Installation Timeout
- **Cause**: Complex software requiring more time
- **Solution**: Increase timeout values in workflow configuration

#### Voice Commands Not Working
- **Cause**: Google Assistant integration disabled
- **Solution**: Verify Google Assistant API credentials

## Support

For technical support or questions about this implementation:
- **ServiceNow Admin**: Create incident in Service Management
- **Humanoid Integration**: Contact Robotics Support Team  
- **Documentation Updates**: Submit change request through normal channels

## Version History

- **v1.0.0**: Initial implementation with basic workflow
- **v1.1.0**: Added Humanoid robot integration
- **v1.2.0**: Enhanced error handling and monitoring
- **v1.3.0**: Added IoT device control capabilities