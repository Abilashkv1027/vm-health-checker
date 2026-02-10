# VM Health Checker

A bash script to analyze and monitor the health of Ubuntu virtual machines based on CPU, memory, and disk space utilization.

## Overview

**VM Health Checker** is a lightweight shell script designed to monitor the health status of Ubuntu-based virtual machines. It evaluates system performance by analyzing three critical metrics: CPU usage, memory usage, and disk space usage. The script provides quick health status reports and detailed explanations of the assessment criteria.

## Features

- ✅ **CPU Usage Monitoring**: Tracks real-time CPU utilization
- ✅ **Memory Usage Monitoring**: Analyzes RAM consumption
- ✅ **Disk Space Monitoring**: Checks root partition disk usage
- ✅ **Health Status Report**: Provides clear pass/fail assessment
- ✅ **Detailed Explanation Mode**: Offers comprehensive breakdown of health criteria when requested
- ✅ **Color-Coded Output**: Visual indicators for easy result interpretation
- ✅ **Easy to Use**: Simple command-line interface
- ✅ **Ubuntu Optimized**: Designed and tested for Ubuntu systems

## Health Assessment Criteria

The script evaluates VM health using a **60% utilization threshold** for each metric:

### ✓ Healthy Status
- **CPU Usage < 60%**: System has adequate processing capacity
- **Memory Usage < 60%**: Sufficient free memory available
- **Disk Usage < 60%**: Plenty of storage space remaining

### ✗ NOT Healthy Status
- **CPU Usage ≥ 60%**: System is under heavy processing load
- **Memory Usage ≥ 60%**: High memory consumption may cause performance issues
- **Disk Usage ≥ 60%**: Low disk space may impact system stability

**Overall Status**: 
- **HEALTHY**: All three metrics are below the 60% threshold
- **NOT HEALTHY**: Any one metric reaches or exceeds the 60% threshold

## Prerequisites

- Ubuntu Linux distribution (18.04 LTS or later)
- Bash shell (4.0 or later)
- Standard utilities: `top`, `free`, `df`, `awk`, `grep`, `bc`
- Root or sudo privileges (optional, for detailed system information)

## Installation

### Clone the Repository
```bash
git clone https://github.com/Abilashkv1027/vm-health-checker.git
cd vm-health-checker
```

### Make the Script Executable
```bash
chmod +x vm-health-check.sh
```

## Usage

### Basic Health Check
Run the script without any arguments to get a quick health status:

```bash
./vm-health-check.sh
```

**Output Example**:
```
==========================================
     VM HEALTH CHECK REPORT
==========================================

✓ CPU Usage: 35.42% (Healthy - Below 60%)
✓ Memory Usage: 42.18% (Healthy - Below 60%)
✓ Disk Usage: 45% (Healthy - Below 60%)

==========================================
Overall Status: HEALTHY
==========================================
```

### Health Check with Explanation
Use the `explain` argument to get detailed health status with criteria explanation:

```bash
./vm-health-check.sh explain
```

**Output Example**:
```
==========================================
     VM HEALTH CHECK REPORT
==========================================

✓ CPU Usage: 35.42% (Healthy - Below 60%)
✓ Memory Usage: 42.18% (Healthy - Below 60%)
✓ Disk Usage: 45% (Healthy - Below 60%)

==========================================
Overall Status: HEALTHY
==========================================

==========================================
   VM HEALTH CHECK CRITERIA EXPLANATION
==========================================

This script monitors three key metrics to determine VM health:

1. CPU USAGE
   - Threshold: 60%
   - Healthy: CPU utilization < 60%
   - NOT Healthy: CPU utilization >= 60%
   - Impact: High CPU usage indicates system overload or resource contention

2. MEMORY USAGE
   - Threshold: 60%
   - Healthy: Memory utilization < 60%
   - NOT Healthy: Memory utilization >= 60%
   - Impact: High memory usage may lead to swapping and performance degradation

3. DISK USAGE
   - Threshold: 60%
   - Healthy: Disk utilization < 60%
   - NOT Healthy: Disk utilization >= 60%
   - Impact: Low disk space may affect system stability and log generation

OVERALL STATUS:
   - Healthy: ALL three metrics are below 60% threshold
   - NOT Healthy: ANY one metric is at or above 60% threshold

==========================================
```

### Help Information
Display usage instructions:

```bash
./vm-health-check.sh help
```

Or use standard help flags:

```bash
./vm-health-check.sh -h
./vm-health-check.sh --help
```

## Script Details

### Functions

1. **`check_cpu()`**: Measures CPU usage using the `top` command and compares against the 60% threshold
2. **`check_memory()`**: Calculates memory utilization using the `free` command and compares against the 60% threshold
3. **`check_disk()`**: Gets disk usage of the root partition using the `df` command and compares against the 60% threshold
4. **`display_explanation()`**: Provides detailed information about health assessment criteria
5. **`display_results()`**: Formats and displays the health check report with color coding
6. **`usage()`**: Shows help and usage information
7. **`main()`**: Orchestrates the script execution and handles command-line arguments

### Metrics Explanation

#### CPU Usage
- **How it's calculated**: Extracted from `top` command's idle percentage, subtracted from 100%
- **Why it matters**: High CPU usage indicates system overload, bottlenecks, or resource contention
- **Action if NOT healthy**: Investigate running processes with `top` or `ps aux`, consider scaling resources

#### Memory Usage
- **How it's calculated**: Used memory divided by total memory, multiplied by 100
- **Why it matters**: High memory usage may cause system to use swap space, severely degrading performance
- **Action if NOT healthy**: Check running processes with `ps aux`, increase RAM, or optimize applications

#### Disk Usage
- **How it's calculated**: Used disk space percentage on the root partition (`/`)
- **Why it matters**: Low disk space can cause system instability, prevent log file writes, and crash applications
- **Action if NOT healthy**: Clean up temporary files, archive logs, remove unused packages, or increase storage

## Automation and Scheduling

### Cron Job Setup
To run the health check periodically, add a cron job:

```bash
# Open crontab editor
crontab -e

# Add this line to run health check every hour
0 * * * * /path/to/vm-health-checker/vm-health-check.sh >> /var/log/vm-health-check.log 2>&1

# Or with explanation, every 6 hours
0 */6 * * * /path/to/vm-health-checker/vm-health-check.sh explain >> /var/log/vm-health-check.log 2>&1
```

### Integration with Monitoring Systems
The script can be integrated with monitoring systems:

```bash
# Send output to syslog
./vm-health-check.sh | logger -t vm-health-check

# Parse output for integration with monitoring dashboards
./vm-health-check.sh explain | grep "Overall Status"
```

## Exit Codes

The script uses standard exit codes:
- **0**: Script executed successfully
- **1**: Invalid command-line argument provided

## Troubleshooting

### Issue: Command not found errors
**Solution**: Ensure all required utilities are installed:
```bash
sudo apt-get update
sudo apt-get install sysstat coreutils
```

### Issue: Permission denied
**Solution**: Make the script executable:
```bash
chmod +x vm-health-check.sh
```

### Issue: Inaccurate CPU readings
**Solution**: The script uses `top` for CPU calculation. For more accurate readings, run with sudo or allow the user appropriate permissions.

## Performance Impact

- **Lightweight**: Script execution takes < 1 second
- **Minimal resource usage**: Negligible CPU and memory overhead
- **Non-intrusive**: Does not require elevated privileges for basic operation

## Platform Support

- ✅ Ubuntu 18.04 LTS
- ✅ Ubuntu 20.04 LTS
- ✅ Ubuntu 22.04 LTS
- ✅ Ubuntu 24.04 LTS
- ✅ Other Debian-based distributions (with standard utilities installed)

## Contributing

Contributions are welcome! Feel free to:
- Report issues and suggest improvements
- Submit pull requests with enhancements
- Share use cases and feedback

## License

This project is provided as-is for educational and operational purposes.

## Support and Documentation

For issues, questions, or feature requests, please open an issue in the GitHub repository.

## Author

**VM Health Checker** - Created for Ubuntu system administration and monitoring purposes.

---

**Last Updated**: February 2026
**Version**: 1.0.0