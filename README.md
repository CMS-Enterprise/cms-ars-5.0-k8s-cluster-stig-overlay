# cms-ars-5.0-k8s-cluster-stig-overlay
**CMS’ ISPG (Information Security and Privacy Group) decided to discontinue funding the customization of MITRE’s Security Automation Framework (SAF) for CMS after September 2023. This repo is now in archive mode, but still accessible. For more information about SAF with current links, see https://security.cms.gov/learn/security-automation-framework-saf**


InSpec profile to validate the secure configuration of Kubernetes cluster against [DISA's](https://public.cyber.mil/stigs/) Kubernetes Secure Technical Implementation Guide (STIG) Version 1 Release 1 tailored for CMS ARS 5.0.

The Kubernetes STIG includes security requirements for both the Kubernetes cluster itself and the nodes that comprise it. This profile includes the checks for the cluster portion. It is intended  to be used in conjunction with the <b>[Kubernetes Node]([https://github.com/](https://github.com/mitre/cms-ars-5.0-k8s-node-stig-overlay))</b> profile that performs automated compliance checks of the Kubernetes nodes.

## Getting Started  
### InSpec (CINC-auditor) setup
For maximum flexibility/accessibility, we’re moving to “cinc-auditor”, the open-source packaged binary version of Chef InSpec, compiled by the CINC (CINC Is Not Chef) project in coordination with Chef using Chef’s always-open-source InSpec source code. For more information: https://cinc.sh/

It is intended and recommended that CINC-auditor and this profile overlay be run from a __"runner"__ host (such as a DevOps orchestration server, an administrative management system, or a developer's workstation/laptop) against the target. This can be any Unix/Linux/MacOS or Windows runner host, with access to the Internet.

__For the best security of the runner, always install on the runner the _latest version_ of CINC-auditor.__ 

__The simplest way to install CINC-auditor is to use this command for a UNIX/Linux/MacOS runner platform:__
```
curl -L https://omnitruck.cinc.sh/install.sh | sudo bash -s -- -P cinc-auditor
```

__or this command for Windows runner platform (Powershell):__
```
. { iwr -useb https://omnitruck.cinc.sh/install.ps1 } | iex; install -project cinc-auditor
```
To confirm successful install of cinc-auditor:
```
cinc-auditor -v
```
> sample output:  _4.24.32_

Latest versions and other installation options are available at https://cinc.sh/start/auditor/.

### Requirements

#### Kubernetes Cluster
- Kubernetes Platform deployment
- Access to the Kubernetes Cluster API
- Kubernetes Cluster Admin credentials cached on the runner.

#### Install InSpec Kubernetes Train
Kubernetes Train allows InSpec to send request over Kubernetes API to inspect the Kubernetes Cluster.

```sh
# Use one of the two following approaches for installing train-kubernetes.

# if InSpec was installed as a gem, use the system gem binary to install train-kubernetes.
# to check, compare `which inspec` to $GEM_HOME, if they match use
gem install train-kubernetes -v 0.1.6

# if InSpec was installed as a package, use the embedded gem binary to install train-kubernetes.
# to check, compare `which inspec` to $GEM_HOME, if they do not match or if $GEM_HOME is null use
sudo /opt/cinc-auditor/embedded/bin/gem install train-kubernetes -v 0.1.6

# Import gem as InSpec plugin
cinc-auditor plugin install train-kubernetes

#If it has the version set to "= 0.1.6", modify it to "0.1.6" and save the file.
vi ~/.inspec/plugins.json

# Run the following command to confirm train-kubernetes is installed
cinc-auditor plugin list
```

#### Validate access to Kubernetes API
The profile makes use of the `kubectl` utility to access the Kubernetes API. The runner host must have `kubectl` installed -- see the [Kubernetes documentation for tools](https://kubernetes.io/docs/tasks/tools/) for details.

A host's connection to the Kubernetes API is established using credentials recorded in the `kubeconfig` file. For the profile to use the Kubernetes API, the runner host must either have a valid `kubeconfig` file either in the default location ($HOME/.kube/config) or have designated a file as the `kubeconfig` file using the `$KUBECONFIG` environment variable. See the [Kubernetes documentation for kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) for details.

You can test if the runner host has access to the Kubernetes API by running `kubectl` from the command line:

```sh
kubectl get nodes

# Upon success try the following command to validate InSpec can reach the cluster API
cinc-auditor detect -t k8s://
```

## Specify your BASELINE system categorization as an environment variable
### (if undefined defaults to Moderate baseline)

```
# BASELINE (choices: Low, Low-HVA, Moderate, Moderate-HVA, High, High-HVA)
# (if undefined defaults to Moderate baseline)

on linux:
BASELINE=High

on Powershell:
$env:BASELINE="High"
```

## Tailoring to Your Environment

The following inputs may be configured in an inputs ".yml" file for the profile to run correctly for your specific environment. More information about InSpec inputs can be found in the [InSpec Profile Documentation](https://www.inspec.io/docs/reference/profiles/).

```yaml
# Minimum version of Kubernetes deployment (default 'v1.19.5')
k8s_minium_version: 
```
### How to execute this instance  
(See: https://www.inspec.io/docs/reference/cli/)

## Running the Profile

Executing the profile by executing directly it from this GitHub repository:
```
# How to run (linux)
BASELINE=<your_system_categorization> cinc-auditor exec https://github.com/cms-enterprise/cms-ars-5.0-k8s-cluster-stig-overlay/archive/main.tar.gz --t k8s:// --input-file <path_to_your_input_file/name_of_your_input_file.yml> --reporter cli json:cluster-results.json
```

Executing the profile by downloading it to the runner:
(Git is required to clone the InSpec profile using the instructions below. Git can be downloaded from the [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) site.)
```
git clone https://github.com/cms-enterprise/cms-ars-5.0-k8s-cluster-stig-overlay.git
cd cms-ars-5.0-k8s-cluster-stig-overlay
# How to run (linux)
BASELINE=<your_system_categorization> cinc-auditor exec . -t k8s:// --input-file <path_to_your_input_file/name_of_your_input_file.yml> --reporter cli json:cluster-results.json
```

## Running This Baseline from a local Archive copy

If your runner is not always expected to have direct access to GitHub, use the following steps to create an archive bundle of this profile and all of its dependent tests:

```
mkdir profiles
cd profiles
git clone https://github.com/cms-enterprise/cms-ars-5.0-k8s-cluster-stig-overlay.git
cinc-auditor archive cms-ars-5.0-k8s-cluster-stig-overlay
# How to run (linux)
BASELINE=<your_system_categorization> cinc-auditor exec <archive name> -t k8s:// --input-file <path_to_your_input_file/name_of_your_input_file.yml> --reporter cli json:cluster-results.json
```

For every successive run, follow these steps to always have the latest version of this overlay and dependent profiles:

```
cd cms-ars-5.0-k8s-cluster-stig-overlay
git pull
cd ..
cinc-auditor archive cms-ars-5.0-k8s-cluster-stig-overlay --overwrite
# How to run (linux)
BASELINE=<your_system_categorization> cinc-auditor exec <archive name> -t k8s:// --input-file <path_to_your_input_file/name_of_your_input_file.yml> --reporter cli json:cluster-results.json
```

## Using Heimdall for Viewing the JSON Results

![Heimdall Lite 2.0 Demo GIF](https://github.com/mitre/heimdall2/blob/master/apps/frontend/public/heimdall-lite-2.0-demo-5fps.gif)

The JSON results output file can be loaded into **[heimdall-lite](https://heimdall-lite.cms.gov/)** for a user-interactive, graphical view of the InSpec results.	

The JSON InSpec results file may also be loaded into a **[full heimdall server](https://github.com/mitre/heimdall2)**, allowing for additional functionality such as to store and compare multiple profile runs.		

## Authors

- Will Dower - [wdower](https://github.com/wdower)
- Shivani Karikar - [karikarshivani](https://github.com/karikarshivani)
- Sumaa Sayed - [ssayed118](https://github.com/ssayed118)

## Special Thanks
- Rony Xavier - [rx294](https://github.com/rx294)
- Eugene Aronne - [ejaronne](https://github.com/ejaronne)

## Contributing and Getting Help
To report a bug or feature request, please open an [issue](https://github.com/CMS-Enterprise/cms-ars-5.0-k8s-cluster-stig-overlay/issues/new).

### NOTICE

© 2018-2022 The MITRE Corporation.

Approved for Public Release; Distribution Unlimited. Case Number 18-3678.

### NOTICE		

MITRE hereby grants express written permission to use, reproduce, distribute, modify, and otherwise leverage this software to the extent permitted by the licensed terms provided in the LICENSE.md file included with this project.

### NOTICE
This software was produced for the U. S. Government under Contract Number HHSM-500-2012-00008I, and is subject to Federal Acquisition Regulation Clause 52.227-14, Rights in Data-General.

No other use other than that granted to the U. S. Government, or to those acting on behalf of the U. S. Government under that Clause is authorized without the express written permission of The MITRE Corporation.		

For further information, please contact The MITRE Corporation, Contracts Management Office, 7515 Colshire Drive, McLean, VA 22102-7539, (703) 983-6000.

## NOTICE

DISA STIGs are published at: https://public.cyber.mil/stigs/
