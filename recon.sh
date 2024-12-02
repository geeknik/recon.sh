#!/bin/bash

# Author: geeknik
# Usage: ./recon.sh domain.tld

if [ $# -eq 0 ]; then
    echo "Usage: $0 <domain.tld>"
    exit 1
fi

TARGET=$1
OUTDIR=~/recon/$TARGET
mkdir -p $OUTDIR

echo "[+] Starting recon on $TARGET"
echo

# Step 1: Subdomain Enumeration
echo "[+] Running subdomain enumeration..."

subfinder -d $TARGET -all -silent > $OUTDIR/subdomains_subfinder.txt
assetfinder --subs-only $TARGET > $OUTDIR/subdomains_assetfinder.txt
amass enum -passive -d $TARGET -o $OUTDIR/subdomains_amass.txt
chaos -d $TARGET -silent > $OUTDIR/subdomains_chaos.txt
knockknock $TARGET -o $OUTDIR/subdomains_knockknock.txt

cat $OUTDIR/subdomains_*.txt | sort -u > $OUTDIR/subdomains_all.txt

echo "[+] Subdomains collected: $(wc -l < $OUTDIR/subdomains_all.txt)"
echo

# Step 2: DNS Resolution
echo "[+] Resolving subdomains..."

dnsx -l $OUTDIR/subdomains_all.txt -o $OUTDIR/resolved_subdomains.txt

echo "[+] Resolved subdomains: $(wc -l < $OUTDIR/resolved_subdomains.txt)"
echo

# Step 3: Port Scanning
echo "[+] Performing port scan..."

naabu -l $OUTDIR/resolved_subdomains.txt -top-ports 1000 -o $OUTDIR/port_scan.txt

echo "[+] Open ports found: $(wc -l < $OUTDIR/port_scan.txt)"
echo

# Step 4: HTTP Probing
echo "[+] Probing for HTTP services..."

httpx -l $OUTDIR/resolved_subdomains.txt -ports 80,443,8080,8443 -title -status-code -silent -o $OUTDIR/http_services.txt

awk '{print $1}' $OUTDIR/http_services.txt > $OUTDIR/live_hosts.txt

echo "[+] Live hosts detected: $(wc -l < $OUTDIR/live_hosts.txt)"
echo

# Step 5: URL Collection
echo "[+] Collecting URLs from various sources..."

gau --subs $TARGET | sort -u > $OUTDIR/urls_gau.txt
waybackurls $TARGET | sort -u > $OUTDIR/urls_wayback.txt
gauplus -t 20 --random-agent -b webp,pdf,webm,mp4,mp3,jpg,jpeg,gif,png,css,ico | sort -u > $OUTDIR/urls_gauplus.txt
xurlfind3r -d $TARGET -o $OUTDIR/urls_xurlfind3r.txt
gospider -S $OUTDIR/live_hosts.txt -d 1 --other-source --sitemap --robots -t 10 -o $OUTDIR/gospider_output
find $OUTDIR/gospider_output -type f -name "*.txt" -exec cat {} \; | sort -u > $OUTDIR/urls_gospider.txt
hakrawler -url $TARGET -depth 2 -plain | sort -u > $OUTDIR/urls_hakrawler.txt
katana -u $TARGET -d 2 -silent -o $OUTDIR/urls_katana.txt
python3 ~/waymore/waymore.py --input $TARGET --output $OUTDIR/urls_waymore.txt --threads 10 --verbose

cat $OUTDIR/urls_*.txt | sort -u > $OUTDIR/all_urls.txt

echo "[+] Total unique URLs collected: $(wc -l < $OUTDIR/all_urls.txt)"
echo

# Step 6: Parameter Extraction
echo "[+] Extracting parameters from URLs..."

unfurl --unique keys < $OUTDIR/all_urls.txt > $OUTDIR/parameters.txt

echo "[+] Parameters found: $(wc -l < $OUTDIR/parameters.txt)"
echo

# Step 7: JavaScript File Extraction
echo "[+] Identifying JavaScript files..."

subjs -i $OUTDIR/live_hosts.txt | sort -u > $OUTDIR/js_files.txt

echo "[+] JavaScript files collected: $(wc -l < $OUTDIR/js_files.txt)"
echo

# Step 8: JavaScript Analysis
echo "[+] Analyzing JavaScript files with jsluice..."

mkdir -p $OUTDIR/jsluice_reports

while read jsfile; do
    filename=$(echo $jsfile | md5sum | cut -d' ' -f1)
    jsluice $jsfile -o $OUTDIR/jsluice_reports/$filename.txt
done < $OUTDIR/js_files.txt

echo "[+] JavaScript analysis completed."
echo

# Step 9: Screenshotting
echo "[+] Capturing screenshots of live hosts..."

gowitness file -f $OUTDIR/live_hosts.txt -F $OUTDIR/gowitness_report.html

echo "[+] Screenshots saved."
echo

# Step 10: Vulnerability Scanning with Nuclei
echo "[+] Scanning for vulnerabilities with Nuclei..."

nuclei -l $OUTDIR/live_hosts.txt -o $OUTDIR/nuclei_findings.txt

echo "[+] Nuclei scan completed."
echo

# Step 11: XSS Scanning with Dalfox
echo "[+] Scanning for XSS vulnerabilities with Dalfox..."

dalfox file $OUTDIR/all_urls.txt -o $OUTDIR/dalfox_results.txt

echo "[+] Dalfox scan completed."
echo

# Step 12: Sensitive Data Lookup
echo "[+] Performing sensitive data lookup with sdlookup..."

sdlookup -d $TARGET -o $OUTDIR/sensitive_data.txt

echo "[+] Sensitive data lookup completed."
echo

# Step 13: Additional Fuzzing with Surf
echo "[+] Performing content discovery with Surf..."

surf -u $OUTDIR/live_hosts.txt -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -o $OUTDIR/surf_results.txt

echo "[+] Surf content discovery completed."
echo

# Step 14: Summary
echo "[+] Reconnaissance completed for $TARGET."
echo "Results are saved in $OUTDIR."
