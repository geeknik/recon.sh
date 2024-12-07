# recon.sh
This script performs comprehensive domain reconnaissance using various security assessment tools. It automates the process of gathering information about a target domain through passive and active reconnaissance methods.

## Disclaimer

This tool is designed for security professionals conducting authorized security assessments. Always ensure you have explicit permission to test any target domain. Unauthorized scanning may be illegal in your jurisdiction.

## Features

The script performs a systematic reconnaissance process including:

1. Subdomain Enumeration: Discovers subdomains using multiple tools (subfinder, assetfinder, amass, chaos, knockknock)
2. DNS Resolution: Validates discovered subdomains
3. Port Scanning: Identifies open ports on discovered hosts
4. HTTP Service Detection: Probes for web services and captures metadata
5. URL Discovery: Collects URLs from various sources including historical data
6. Parameter Analysis: Extracts and analyzes URL parameters
7. JavaScript Analysis: Identifies and analyzes JavaScript files
8. Visual Reconnaissance: Captures screenshots of live web services
9. Vulnerability Assessment: Performs automated security checks
10. Content Discovery: Conducts thorough fuzzing for hidden content

## Prerequisites

The following tools must be installed and available in your PATH:

- subfinder
- assetfinder
- amass
- chaos
- knockknock
- dnsx
- naabu
- httpx
- gau
- waybackurls
- gauplus
- xurlfind3r
- gospider
- hakrawler
- katana
- waymore
- unfurl
- subjs
- jsluice
- gowitness
- nuclei
- dalfox
- sdlookup
- surf

Additionally, you'll need:
- Python 3.x
- Bash shell environment
- SecLists wordlist collection

## Installation

1. Clone this repository:
```bash
git clone [[repository-url]](https://github.com/geeknik/recon.sh/)
cd recon.sh
```

2. Make the script executable:
```bash
chmod +x recon.sh
```

## Usage

Run the script by providing a target domain:

```bash
./recon.sh domain.tld
```

The script will create a directory structure under `~/recon.sh/[domain]` containing all output files.

## Output Structure

The script generates the following directory structure:

```
~/recon/[domain]/
├── subdomains_subfinder.txt
├── subdomains_assetfinder.txt
├── subdomains_amass.txt
├── subdomains_chaos.txt
├── subdomains_knockknock.txt
├── subdomains_all.txt
├── resolved_subdomains.txt
├── port_scan.txt
├── http_services.txt
├── live_hosts.txt
├── urls_gau.txt
├── urls_wayback.txt
├── urls_gauplus.txt
├── urls_xurlfind3r.txt
├── gospider_output/
├── urls_gospider.txt
├── urls_hakrawler.txt
├── urls_katana.txt
├── urls_waymore.txt
├── all_urls.txt
├── parameters.txt
├── js_files.txt
├── jsluice_reports/
├── gowitness_report.html
├── nuclei_findings.txt
├── dalfox_results.txt
├── sensitive_data.txt
└── surf_results.txt

## Workflow Details

### 1. Subdomain Enumeration
The script begins by discovering subdomains using multiple tools to ensure comprehensive coverage. Results are merged and deduplicated.

### 2. DNS Resolution
Discovered subdomains are validated through DNS resolution to identify active hosts.

### 3. Port Scanning
Active hosts are scanned for open ports, focusing on the top 1000 ports for efficiency.

### 4. HTTP Service Detection
The script identifies web services running on standard and common alternate ports (80, 443, 8080, 8443).

### 5. URL Collection
Multiple tools are used to gather URLs, including historical data from web archives and crawling of live sites.

### 6. Parameter Analysis
URL parameters are extracted and analyzed to identify potential testing points.

### 7. JavaScript Analysis
JavaScript files are identified and analyzed for potential security insights.

### 8. Visual Reconnaissance
Screenshots are captured of live web services for manual review.

### 9. Vulnerability Assessment
Automated security checks are performed using Nuclei and Dalfox.

### 10. Content Discovery
Additional content discovery is performed using common wordlists.

## Security Considerations

- This tool performs active scanning which may be detected by security monitoring systems
- Some tools may generate significant network traffic
- Always verify you have authorization before scanning any domain
- Consider rate limiting if scanning public services
- Review and understand all tool outputs before acting on them

## Contributing

Contributions are welcome! Please feel free to submit pull requests with improvements.

## Acknowledgments

This script integrates various open-source security tools. We acknowledge and thank their respective authors and maintainers.
