#!/bin/bash

# Validation Test for ServiceNow Non-Standard Software Request Flow
# This script validates all components of the implementation

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICENOW_DIR="$SCRIPT_DIR/servicenow"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test functions
test_start() {
    TESTS_RUN=$((TESTS_RUN + 1))
    echo -e "${BLUE}[TEST $TESTS_RUN]${NC} $1"
}

test_pass() {
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "${GREEN}  ✓ PASS${NC} $1"
}

test_fail() {
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo -e "${RED}  ✗ FAIL${NC} $1"
}

# Test 1: File Structure Validation
test_file_structure() {
    test_start "Validating file structure"
    
    local required_files=(
        "servicenow/flows/non_standard_software_request_flow.json"
        "servicenow/workflows/non_standard_software_workflow.xml"
        "servicenow/tables/software_request_table.xml"
        "servicenow/scripts/HumanoidIntegration.js"
        "servicenow/scripts/business_rule_auto_trigger.xml"
        "SERVICENOW_FLOW_DOCUMENTATION.md"
        "deploy_servicenow_flow.sh"
    )
    
    local all_exist=true
    for file in "${required_files[@]}"; do
        if [ -f "$SCRIPT_DIR/$file" ]; then
            test_pass "File exists: $file"
        else
            test_fail "Missing file: $file"
            all_exist=false
        fi
    done
    
    if [ "$all_exist" = true ]; then
        test_pass "All required files present"
    else
        test_fail "Some required files are missing"
    fi
}

# Test 2: JSON Configuration Validation
test_json_validation() {
    test_start "Validating JSON configuration files"
    
    local json_file="$SERVICENOW_DIR/flows/non_standard_software_request_flow.json"
    
    if command -v jq &> /dev/null; then
        if jq . "$json_file" > /dev/null 2>&1; then
            test_pass "Flow configuration JSON is valid"
            
            # Test specific JSON structure
            local flow_name=$(jq -r '.flow_name' "$json_file")
            if [ "$flow_name" = "Non-Standard Software Request Flow" ]; then
                test_pass "Flow name is correct"
            else
                test_fail "Flow name is incorrect: $flow_name"
            fi
            
            local stages_count=$(jq '.stages | length' "$json_file")
            if [ "$stages_count" -eq 6 ]; then
                test_pass "Correct number of workflow stages (6)"
            else
                test_fail "Incorrect number of stages: $stages_count"
            fi
            
            local humanoid_enabled=$(jq -r '.humanoid_integration.enabled' "$json_file")
            if [ "$humanoid_enabled" = "true" ]; then
                test_pass "Humanoid integration is enabled"
            else
                test_fail "Humanoid integration is not enabled"
            fi
            
        else
            test_fail "Flow configuration JSON is invalid"
        fi
    else
        test_fail "jq not available for JSON validation"
    fi
}

# Test 3: XML Structure Validation
test_xml_validation() {
    test_start "Validating XML structure"
    
    local xml_files=(
        "$SERVICENOW_DIR/workflows/non_standard_software_workflow.xml"
        "$SERVICENOW_DIR/tables/software_request_table.xml"
        "$SERVICENOW_DIR/scripts/business_rule_auto_trigger.xml"
    )
    
    if command -v xmllint &> /dev/null; then
        for xml_file in "${xml_files[@]}"; do
            if xmllint --noout "$xml_file" 2>/dev/null; then
                test_pass "Valid XML: $(basename "$xml_file")"
            else
                test_fail "Invalid XML: $(basename "$xml_file")"
            fi
        done
    else
        test_fail "xmllint not available for XML validation"
    fi
}

# Test 4: JavaScript Syntax Validation
test_javascript_validation() {
    test_start "Validating JavaScript syntax"
    
    local js_file="$SERVICENOW_DIR/scripts/HumanoidIntegration.js"
    
    if command -v node &> /dev/null; then
        if node -c "$js_file" 2>/dev/null; then
            test_pass "JavaScript syntax is valid"
        else
            test_fail "JavaScript syntax errors found"
        fi
    else
        test_fail "Node.js not available for JavaScript validation"
    fi
}

# Test 5: Documentation Completeness
test_documentation() {
    test_start "Validating documentation completeness"
    
    local doc_file="$SCRIPT_DIR/SERVICENOW_FLOW_DOCUMENTATION.md"
    
    local required_sections=(
        "## Overview"
        "## Flow Architecture"
        "## Workflow Stages"
        "## Humanoid Integration Features"
        "## Configuration"
        "## Usage Instructions"
        "## Error Handling"
        "## Troubleshooting"
    )
    
    for section in "${required_sections[@]}"; do
        if grep -q "$section" "$doc_file"; then
            test_pass "Documentation section exists: $section"
        else
            test_fail "Missing documentation section: $section"
        fi
    done
}

# Test 6: Deployment Script Validation
test_deployment_script() {
    test_start "Validating deployment script"
    
    local deploy_script="$SCRIPT_DIR/deploy_servicenow_flow.sh"
    
    if [ -x "$deploy_script" ]; then
        test_pass "Deployment script is executable"
    else
        test_fail "Deployment script is not executable"
    fi
    
    # Test help function
    if "$deploy_script" --help >/dev/null 2>&1; then
        test_pass "Deployment script help function works"
    else
        test_fail "Deployment script help function failed"
    fi
    
    # Test validation function
    if "$deploy_script" --validate >/dev/null 2>&1; then
        test_pass "Deployment script validation function works"
    else
        test_fail "Deployment script validation function failed"
    fi
}

# Test 7: Integration Logic Validation
test_integration_logic() {
    test_start "Validating integration logic"
    
    local flow_config="$SERVICENOW_DIR/flows/non_standard_software_request_flow.json"
    
    # Check for Humanoid integration points
    if grep -q "humanoid_integration" "$flow_config"; then
        test_pass "Humanoid integration configuration found"
    else
        test_fail "Humanoid integration configuration missing"
    fi
    
    # Check for Google Assistant integration
    if grep -q "google_assistant" "$flow_config"; then
        test_pass "Google Assistant integration configured"
    else
        test_fail "Google Assistant integration not configured"
    fi
    
    # Check for IoT integration
    if grep -q "iot_enabled" "$flow_config"; then
        test_pass "IoT integration configured"
    else
        test_fail "IoT integration not configured"
    fi
    
    # Check for voice commands
    if grep -q "voice_command" "$flow_config"; then
        test_pass "Voice command integration found"
    else
        test_fail "Voice command integration missing"
    fi
}

# Test 8: Workflow Stage Validation
test_workflow_stages() {
    test_start "Validating workflow stages"
    
    local flow_config="$SERVICENOW_DIR/flows/non_standard_software_request_flow.json"
    
    local expected_stages=(
        "Initial Validation"
        "Manager Approval"
        "Technical Review"
        "Procurement & Installation"
        "Installation Execution"
        "Post-Installation Validation"
    )
    
    for stage in "${expected_stages[@]}"; do
        if grep -q "$stage" "$flow_config"; then
            test_pass "Workflow stage found: $stage"
        else
            test_fail "Missing workflow stage: $stage"
        fi
    done
}

# Main test execution
run_all_tests() {
    echo "Starting ServiceNow Flow Implementation Validation"
    echo "=================================================="
    echo
    
    test_file_structure
    echo
    test_json_validation
    echo
    test_xml_validation
    echo
    test_javascript_validation
    echo
    test_documentation
    echo
    test_deployment_script
    echo
    test_integration_logic
    echo
    test_workflow_stages
    echo
    
    # Test summary
    echo "Test Summary:"
    echo "============="
    echo "Tests Run: $TESTS_RUN"
    echo "Tests Passed: $TESTS_PASSED"
    echo "Tests Failed: $TESTS_FAILED"
    echo
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed! ✓${NC}"
        echo "The ServiceNow flow implementation is ready for deployment."
        exit 0
    else
        echo -e "${RED}Some tests failed! ✗${NC}"
        echo "Please fix the issues before deploying."
        exit 1
    fi
}

# Run the tests
run_all_tests