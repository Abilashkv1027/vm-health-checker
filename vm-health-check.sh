#!/bin/bash

# VM Health Check Script
# This script analyzes the health of a virtual machine based on CPU, memory, and disk space usage.
# A VM is considered healthy if all metrics are below 60% utilization.
# A VM is considered NOT healthy if any metric is at or above 60% utilization.

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Global variables to track health status
overall_health="Healthy"
health_details=()

# Function to display usage information
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "OPTIONS:"
    echo "  explain     Show detailed explanation of health status criteria"
    echo "  help        Display this help message"
    echo ""
    echo "EXAMPLES:"
    echo "  $0                    # Check VM health and display status"
    echo "  $0 explain            # Check VM health with detailed explanation"
    exit 0
}

# Function to check CPU usage
check_cpu() {
    local cpu_usage
    
    # Get CPU usage percentage (idle time subtracted from 100)
    # Using top command as it's more universally available
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    
    # Round to 2 decimal places
    cpu_usage=$(printf "%.2f" "$cpu_usage")
    
    # Compare CPU usage
    if (( $(echo "$cpu_usage < 60" | bc -l) )); then
        health_details+=("✓ CPU Usage: ${cpu_usage}% (Healthy - Below 60%)")
    else
        health_details+=("✗ CPU Usage: ${cpu_usage}% (NOT Healthy - At or Above 60%)")
        overall_health="NOT Healthy"
    fi
}

# Function to check Memory usage
check_memory() {
    local mem_usage
    
    # Calculate memory usage percentage
    mem_usage=$(free | grep Mem | awk '{printf("%.2f", ($3/$2) * 100)}')
    
    # Compare memory usage
    if (( $(echo "$mem_usage < 60" | bc -l) )); then
        health_details+=("✓ Memory Usage: ${mem_usage}% (Healthy - Below 60%)")
    else
        health_details+=("✗ Memory Usage: ${mem_usage}% (NOT Healthy - At or Above 60%)")
        overall_health="NOT Healthy"
    fi
}

# Function to check Disk usage
check_disk() {
    local disk_usage
    
    # Get disk usage percentage for root partition
    disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    # Compare disk usage
    if [ "$disk_usage" -lt 60 ]; then
        health_details+=("✓ Disk Usage: ${disk_usage}% (Healthy - Below 60%)")
    else
        health_details+=("✗ Disk Usage: ${disk_usage}% (NOT Healthy - At or Above 60%)")
        overall_health="NOT Healthy"
    fi
}

# Function to display explanation
display_explanation() {
    echo ""
    echo "=========================================="
    echo "   VM HEALTH CHECK CRITERIA EXPLANATION"
    echo "=========================================="
    echo ""
    echo "This script monitors three key metrics to determine VM health:"
    echo ""
    echo "1. CPU USAGE"
    echo "   - Threshold: 60%"
    echo "   - Healthy: CPU utilization < 60%"
    echo "   - NOT Healthy: CPU utilization >= 60%"
    echo "   - Impact: High CPU usage indicates system overload or resource contention"
    echo ""
    echo "2. MEMORY USAGE"
    echo "   - Threshold: 60%"
    echo "   - Healthy: Memory utilization < 60%"
    echo "   - NOT Healthy: Memory utilization >= 60%"
    echo "   - Impact: High memory usage may lead to swapping and performance degradation"
    echo ""
    echo "3. DISK USAGE"
    echo "   - Threshold: 60%"
    echo "   - Healthy: Disk utilization < 60%"
    echo "   - NOT Healthy: Disk utilization >= 60%"
    echo "   - Impact: Low disk space may affect system stability and log generation"
    echo ""
    echo "OVERALL STATUS:"
    echo "   - Healthy: ALL three metrics are below 60% threshold"
    echo "   - NOT Healthy: ANY one metric is at or above 60% threshold"
    echo ""
    echo "=========================================="
    echo ""
}

# Function to display results
display_results() {
    echo ""
    echo "=========================================="
    echo "     VM HEALTH CHECK REPORT"
    echo "=========================================="
    echo ""
    
    # Display individual metric details
    for detail in "${health_details[@]}"; do
        echo "$detail"
    done
    
    echo ""
    echo "=========================================="
    
    # Display overall health status with color coding
    if [ "$overall_health" == "Healthy" ]; then
        echo -e "${GREEN}Overall Status: HEALTHY${NC}"
    else
        echo -e "${RED}Overall Status: NOT HEALTHY${NC}"
    fi
    
    echo "=========================================="
    echo ""
}

# Main script execution
main() {
    # Parse command line arguments
    if [ $# -gt 0 ]; then
        case "$1" in
            explain)
                check_cpu
                check_memory
                check_disk
                display_results
                display_explanation
                ;; 
            help|-h|--help)
                usage
                ;;
            *)
                echo "Error: Unknown option '$1'"
                echo "Use 'help' for usage information"
                exit 1
                ;;
        esac
    else
        # Default behavior: check health without explanation
        check_cpu
        check_memory
        check_disk
        display_results
    fi
}

# Run main function
main "$@"