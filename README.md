<div align="center">

![github](https://img.shields.io/badge/GitHub-181717.svg?style=for-the-badge&logo=GitHub&logoColor=white)
![markdown](https://img.shields.io/badge/Markdown-181717.svg?style=for-the-badge&logo=Markdown&logoColor=white)

# Vortex – AWS Resource viewer
An **interactive CLI tool** designed to fetch and display AWS resource information in both JSON and tabular formats, simplifying cloud resource auditing and management.
</div>

---

##  Project Overview

VORTEX is an intuitive and powerful CLI tool that acts as your personal AWS resource explorer. It automates the process of querying and displaying critical information about your AWS infrastructure. Whether you need a quick overview of your EC2 instances, S3 buckets, RDS databases, or more, VORTEX provides instant, organized outputs in both raw JSON for detailed analysis and clean tabular formats for quick readability. It's an essential tool for cloud engineers, developers, and anyone who needs to quickly understand their AWS environment.

---

##  Getting Started
### • Prerequisites
#### 1. AWS CLI: Ensure you have the AWS Command Line Interface installed and configured with appropriate credentials. If not, follow the official AWS CLI installation guide.
```bash
aws configure
```

### • Installation
#### 1. Clone the repository
``` bash
git clone https://github.com/Nilanjan-Mondal/Vortex.git
cd Vortex
```

#### 2. Make the script executable
``` bash
chmod +x vortex.sh
```

### • Usage
``` bash
./vortex.sh <region_name> <aws_service>
```

---

<div align="center">

| Layer      | Tech Used |
|------------|-----------|
|script|![Bash](https://img.shields.io/badge/Bash-121011?style=for-the-badge&logo=gnubash&logoColor=white)

</div>

---

## Directory Structure

```bash


Vortex/
│
├── output_logs/              # Directory to store generated JSON and table files
│   ├── output_<service>.json
│   └── output_<service>_table.txt
│
├── vortex.sh                 # The main VORTEX script
├── README.md                 # Project documentation
└── LICENSE                   # License file

```
---
<br>
<p align="center"><a href="https://github.com/Nilanjan-Mondal/Recovaid/blob/main/LICENSE"><img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=BSD&logoColor=d9e0ee&colorA=363a4f&colorB=b7bdf8"/></a></p>
