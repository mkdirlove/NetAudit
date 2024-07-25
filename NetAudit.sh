#!/bin/bash

# Banner
clear
cat << "EOF"
 _  _     _     _          _ _ _   
| \| |___| |_  /_\ _  _ __| (_) |_  v1.0-dev
| .` / -_)  _|/ _ \ || / _` | |  _|
|_|\_\___|\__/_/ \_\_,_\__,_|_|\__|
    Made with ❤️  by @mkdirlove

EOF

# Function Definitions
perform_network_scan() {
	echo ""
    read -p "Enter target IP or range (e.g., 192.168.1.0/24): " target
    echo "Performing Network Scan on $target..."
    
    if [[ -z "$target" ]]; then
        echo "Error: No target provided."
        return 1
    fi
    
    if ! command -v nmap &> /dev/null; then
        echo "Error: nmap is not installed."
        return 1
    fi

    nmap -sP $target > network_scan.txt
    echo "Network Scan Complete. Results saved to network_scan.txt."
}

perform_vulnerability_assessment() {
	echo ""
    read -p "Enter target IP or domain: " target
    echo "Performing Vulnerability Assessment on $target..."

    if [[ -z "$target" ]]; then
        echo "Error: No target provided."
        return 1
    fi

    if ! command -v nmap &> /dev/null; then
        echo "Error: nmap is not installed."
        return 1
    fi

    nmap --script vuln $target > vuln_assessment.txt
    echo "Vulnerability Assessment Complete. Results saved to vuln_assessment.txt."
}

run_compliance_check() {
	echo ""
    read -p "Enter target IP or range (e.g., 192.168.1.0/24): " target
    echo "Running Compliance Check on $target..."

    if [[ -z "$target" ]]; then
        echo "Error: No target provided."
        return 1
    fi

    if ! command -v nmap &> /dev/null; then
        echo "Error: nmap is not installed."
        return 1
    fi
    
    if ! command -v hydra &> /dev/null; then
        echo "Error: hydra is not installed."
        return 1
    fi

    echo "Checking for open SSH ports..."
    nmap -p 22 --open -sV $target > ssh_compliance.txt

    echo "Checking for weak passwords..."
    hydra -L usernames.txt -P passwords.txt ssh://$target > weak_passwords.txt

    echo "Compliance Check Complete. Results saved to ssh_compliance.txt and weak_passwords.txt."
}

collect_system_info() {
    echo "Gathering System Information..."
    {
        echo "Hostname: $(hostname)"
        echo "Operating System: $(uname -o)"
        echo "Kernel Version: $(uname -r)"
        echo "Uptime: $(uptime -p)"
        echo "Users Currently Logged In: $(who)"
    } > system_info.txt
    echo "System Information Collected. Results saved to system_info.txt."
}

check_password_policy() {
    echo "Checking Password Policy..."
    
    if ! sudo -n true 2>/dev/null; then
        echo "Error: You do not have sudo privileges."
        return 1
    fi

    {
        echo "Password Policy:"
        sudo grep PASS_MAX_DAYS /etc/login.defs
        sudo grep PASS_MIN_DAYS /etc/login.defs
        sudo grep PASS_WARN_AGE /etc/login.defs
    } > password_policy.txt
    echo "Password Policy Check Complete. Results saved to password_policy.txt."
}

check_firewall_status() {
    echo "Checking Firewall Status..."
    
    if ! command -v ufw &> /dev/null; then
        echo "Error: ufw is not installed."
        return 1
    fi

    sudo ufw status verbose > firewall_status.txt
    echo "Firewall Status Check Complete. Results saved to firewall_status.txt."
}

perform_port_scan() {
	echo ""
    read -p "Enter target IP or range (e.g., 192.168.1.0/24): " target
    echo "Performing Port Scan on $target..."

    if [[ -z "$target" ]]; then
        echo "Error: No target provided."
        return 1
    fi

    if ! command -v nmap &> /dev/null; then
        echo "Error: nmap is not installed."
        return 1
    fi

    nmap -p- $target > port_scan.txt
    echo "Port Scan Complete. Results saved to port_scan.txt."
}

perform_service_scan() {
	echo ""
    read -p "Enter target IP or range (e.g., 192.168.1.0/24): " target
    echo "Performing Service Scan on $target..."

    if [[ -z "$target" ]]; then
        echo "Error: No target provided."
        return 1
    fi

    if ! command -v nmap &> /dev/null; then
        echo "Error: nmap is not installed."
        return 1
    fi

    nmap -sV $target > service_scan.txt
    echo "Service Scan Complete. Results saved to service_scan.txt."
}

perform_os_detection() {
	echo ""
    read -p "Enter target IP or range (e.g., 192.168.1.0/24): " target
    echo "Performing OS Detection on $target..."

    if [[ -z "$target" ]]; then
        echo "Error: No target provided."
        return 1
    fi

    if ! command -v nmap &> /dev/null; then
        echo "Error: nmap is not installed."
        return 1
    fi

    nmap -O $target > os_detection.txt
    echo "OS Detection Complete. Results saved to os_detection.txt."
}

perform_banner_grabbing() {
	echo ""
    read -p "Enter target IP or range (e.g., 192.168.1.0/24): " target
    echo "Performing Banner Grabbing on $target..."

    if [[ -z "$target" ]]; then
        echo "Error: No target provided."
        return 1
    fi

    if ! command -v nmap &> /dev/null; then
        echo "Error: nmap is not installed."
        return 1
    fi

    nmap -sV --script=banner $target > banner_grabbing.txt
    echo "Banner Grabbing Complete. Results saved to banner_grabbing.txt."
}

perform_dns_enumeration() {
	echo ""
    read -p "Enter target domain: " target
    echo "Performing DNS Enumeration on $target..."

    if [[ -z "$target" ]]; then
        echo "Error: No target provided."
        return 1
    fi

    if ! command -v nslookup &> /dev/null; then
        echo "Error: nslookup is not installed."
        return 1
    fi

    nslookup -type=any $target > dns_enumeration.txt
    echo "DNS Enumeration Complete. Results saved to dns_enumeration.txt."
}

perform_ssl_tls_scan() {
	echo ""
    read -p "Enter target domain: " target
    echo "Performing SSL/TLS Scan on $target..."

    if [[ -z "$target" ]]; then
        echo "Error: No target provided."
        return 1
    fi

    if ! command -v sslscan &> /dev/null; then
        echo "Error: sslscan is not installed."
        return 1
    fi

    sslscan $target > ssl_tls_scan.txt
    echo "SSL/TLS Scan Complete. Results saved to ssl_tls_scan.txt."
}

generate_html_report() {
    echo "Generating HTML Report..."

    local report_file="audit_report.html"

    if [[ -e $report_file ]]; then
        echo "Warning: $report_file already exists. Overwriting..."
    fi

    {
        echo "<!DOCTYPE html>"
        echo "<html lang=\"en\">"
        echo "<head>"
        echo "    <meta charset=\"UTF-8\">"
        echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
        echo "    <title>Audit Report</title>"
        echo "    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.3/css/bulma.min.css\">"
        echo "    <style>"
        echo "        body { margin: 20px; }"
        echo "        .container { max-width: 1200px; }"
        echo "        h1, h2 { margin-bottom: 20px; }"
        echo "        pre { white-space: pre-wrap; }"
        echo "    </style>"
        echo "</head>"
        echo "<body>"
        echo "    <div class=\"container\">"
        echo "        <h1 class=\"title has-text-centered\">Audit Report</h1>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">Network Scan</h2>"
        echo "            <pre class=\"box\">"
        cat network_scan.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">Vulnerability Assessment</h2>"
        echo "            <pre class=\"box\">"
        cat vuln_assessment.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">Compliance Check</h2>"
        echo "            <pre class=\"box\">"
        cat ssh_compliance.txt
        echo "            </pre>"
        echo "            <pre class=\"box\">"
        cat weak_passwords.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">System Information</h2>"
        echo "            <pre class=\"box\">"
        cat system_info.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">Password Policy</h2>"
        echo "            <pre class=\"box\">"
        cat password_policy.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">Firewall Status</h2>"
        echo "            <pre class=\"box\">"
        cat firewall_status.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">Port Scan</h2>"
        echo "            <pre class=\"box\">"
        cat port_scan.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">Service Scan</h2>"
        echo "            <pre class=\"box\">"
        cat service_scan.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">OS Detection</h2>"
        echo "            <pre class=\"box\">"
        cat os_detection.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">Banner Grabbing</h2>"
        echo "            <pre class=\"box\">"
        cat banner_grabbing.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">DNS Enumeration</h2>"
        echo "            <pre class=\"box\">"
        cat dns_enumeration.txt
        echo "            </pre>"
        echo "        </section>"

        echo "        <section class=\"section\">"
        echo "            <h2 class=\"subtitle\">SSL/TLS Scan</h2>"
        echo "            <pre class=\"box\">"
        cat ssl_tls_scan.txt
        echo "            </pre>"
        echo "        </section>"

        echo "    </div>"
        echo "</body>"
        echo "</html>"
    } > $report_file

    echo "HTML Report Generated: $report_file"
}

# Main Menu
while true; do
    echo "1. Perform Network Scan"
    echo "2. Perform Vulnerability Assessment"
    echo "3. Run Compliance Check"
    echo "4. Collect System Information"
    echo "5. Check Password Policy"
    echo "6. Check Firewall Status"
    echo "7. Perform Port Scan"
    echo "8. Perform Service Scan"
    echo "9. Perform OS Detection"
    echo "10. Perform Banner Grabbing"
    echo "11. Perform DNS Enumeration"
    echo "12. Perform SSL/TLS Scan"
    echo "13. Generate HTML Report"
    echo "14. Exit"
    echo ""
    read -p "Enter your choice: " choice

    case $choice in
        1)
            perform_network_scan
            ;;
        2)
            perform_vulnerability_assessment
            ;;
        3)
            run_compliance_check
            ;;
        4)
            collect_system_info
            ;;
        5)
            check_password_policy
            ;;
        6)
            check_firewall_status
            ;;
        7)
            perform_port_scan
            ;;
        8)
            perform_service_scan
            ;;
        9)
            perform_os_detection
            ;;
        10)
            perform_banner_grabbing
            ;;
        11)
            perform_dns_enumeration
            ;;
        12)
            perform_ssl_tls_scan
            ;;
        13)
            generate_html_report
            ;;
        14)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice, please try again."
            ;;
    esac
done
