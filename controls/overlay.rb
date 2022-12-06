# encoding: UTF-8

overlay_controls = input('overlay_controls')
system_categorization = input('system_categorization')

include_controls 'k8s-cluster-stig-baseline' do

  ## NA due to the requirement not included in CMS ARS 5.0
  unless overlay_controls.empty?
    overlay_controls.each do |overlay_control|
      control overlay_control do
        impact 0.0
        desc "caveat", "Not applicable for this CMS ARS 5.0 overlay, since the requirement is not included in CMS ARS 5.0"
      end
    end
  end

  ## Semantic Changes  
  
  control 'V-242410' do
    title "The Kubernetes API Server must enforce ports, protocols, and services (PPS) that adhere to CMS requirements."
    desc  "Kubernetes API Server PPSs must be controlled and conform to CMS requirements. Those that fall outside CMS requirements must be blocked."
    desc  'check', "
      Change to the /etc/kubernetes/manifests/ directory on the Kubernetes Master Node. Run the command:
      grep kube-apiserver.manifest -I-insecure-port
                    grep kube-apiserver.manifest -I -secure-port
      grep kube-apiserver.manifest -I -etcd-servers *
      -edit manifest file:
      VIM <Manifest Name>
      Review  livenessProbe:
      HttpGet:
      Port:
      Review ports:
      - containerPort:
             hostPort:
        - containerPort:
               hostPort:
        Run Command:
        kubectl describe services –all-namespace
        Search labels for any apiserver names spaces.
        Port:
        Any manifest and namespace PPS or services configuration not in compliance with CMS requirements is a finding.
        Review the information systems documentation and interview the team, gain an understanding of the API Server architecture, and determine applicable PPS. If there are any ports, protocols, and services in the system documentation not in compliance with CMS requirements, this is a finding. 
        Any PPS not set in the system documentation is a finding.
        Review findings against the most recent CMS requirements.
        Verify API Server network boundary with the PPS associated with CMS requirements. Any PPS not in compliance with the CMS requirements is a finding.
      "
      desc 'fix', "Amend any system documentation requiring revision. Update Kubernetes API Server manifest and namespace PPS configuration to comply with CMS requirements."

      describe "Manually confirm Kubernetes API Server enforces ports, protocols, and services (PPS) that adhere to CMS requirements" do
        skip "Manually confirm Kubernetes API Server enforces ports, protocols, and services (PPS) that adhere to CMS requirements"
      end
  end

  control 'V-242411' do
    title "The Kubernetes Scheduler must enforce ports, protocols, and services (PPS) that adhere to CMS requirements."
    desc  "Kubernetes Scheduler PPS must be controlled and conform to CMS requirements. Those ports, protocols, and services that fall outside CMS requirements must be blocked."
    desc  'check', "
      Change to the /etc/kubernetes/manifests/ directory on the Kubernetes Master Node. Run the command:
      grep kube-scheduler.manifest -I -insecure-port
                      grep kube-scheduler.manifest -I -secure-port
      -edit manifest file:
      VIM <Manifest Name>
      Review  livenessProbe:
      HttpGet:
      Port:
      Review ports:
      - containerPort:
             hostPort:
      - containerPort:
             hostPort:
      Run Command:
      kubectl describe services –all-namespace
      Search labels for any scheduler names spaces.
      Port:
      Any manifest and namespace PPS configuration not in compliance with CMS requirements is a finding.
      Review the information systems documentation and interview the team, gain an understanding of the Scheduler architecture, and determine applicable PPS. 
      Any PPS in the system documentation not in compliance with CMS requirements is a finding. 
      Any PPSs not set in the system documentation is a finding.
      Review findings against the most recent CMS requirements.
      Verify Scheduler network boundary with the PPS associated with CMS requirements. Any PPS not in compliance with CMS requirements is a finding.
    "
    desc 'fix', "Amend any system documentation requiring revision. Update Kubernetes Scheduler manifest and namespace PPS configuration to comply with CMS requirements."

    describe "Manually confirm Kubernetes Scheduler enforces ports, protocols, and services (PPS) that adhere to CMS requirements" do
      skip "Manually confirm Kubernetes Scheduler enforces ports, protocols, and services (PPS) that adhere to CMS requirements"
    end
  end

  control 'V-242412' do
    title "The Kubernetes Controllers must enforce ports, protocols, and services (PPS) that adhere to CMS requirements."
    desc  "Kubernetes Controller ports, protocols, and services must be controlled and conform to CMS requirements. Those PPS that fall outside CMS requirements must be blocked."
    desc  'check', "
      Change to the /etc/kubernetes/manifests/ directory on the Kubernetes Master Node. Run the command:
      grep kube-scheduler.manifest -I -insecure-port
                    grep kube-scheduler.manifest -I -secure-port
      -edit manifest file:
      VIM <Manifest Name:
      Review  livenessProbe:
      HttpGet:
      Port:
      Review ports:
      - containerPort:
             hostPort:
      - containerPort:
             hostPort:
      Run Command:
      kubectl describe services –all-namespace
      Search labels for any controller names spaces.
      Port:
      Any manifest and namespace PPS or services configuration not in compliance with CMS requirements is a finding.
      Review the information systems documentation and interview the team, gain an understanding of the Controller architecture, and determine applicable PPS. 
      Any PPS in the system documentation not in compliance with CMS requirements is a finding. 
      Any PPS not set in the system documentation is a finding.
      Review findings against the most recent CMS requirements.
      Verify Controller network boundary with the PPS associated with CMS requirements. Any PPS not in compliance with CMS requirements is a finding.
    "
    desc 'fix', "Amend any system documentation requiring revision. Update Kubernetes Controller manifest and namespace PPS configuration to comply with CMS requirements."

    describe "Manually confirm Kubernetes Controllers enforce ports, protocols, and services (PPS) that adhere to CMS requirements" do
      skip "Manually confirm Kubernetes Controllers enforce ports, protocols, and services (PPS) that adhere to CMS requirements"
    end
  end

  control 'V-242413' do
    title "The Kubernetes etcd must enforce ports, protocols, and services (PPS) that adhere to CMS requirements."
    desc  "Kubernetes etcd PPS must be controlled and conform to CMS requirements. Those PPS that fall outside CMS requirements must be blocked."
    desc  'check', "
      Change to the /etc/kubernetes/manifests/ directory on the Kubernetes Master Node. Run the command:
      grep kube-apiserver.manifest -I -etcd-servers *
      -edit etcd-main.manifest file:
      VIM <Manifest Name:
      Review  livenessProbe:
      HttpGet:
      Port:
      Review ports:
      - containerPort:
             hostPort:
      - containerPort:
             hostPort:
      Run Command:
      kubectl describe services –all-namespace
      Search labels for any apiserver names spaces.
      Port:
      Any manifest and namespace PPS configuration not in compliance with CMS requirements is a finding.
      Review the information systems documentation and interview the team, gain an understanding of the etcd architecture, and determine applicable PPS. 
      Any PPS in the system documentation not in compliance with CMS requirements is a finding. 
      Any PPS not set in the system documentation is a finding.
      Review findings against the most recent CMS requirements.
      Verify etcd network boundary with the PPS associated withCMS requirements. Any PPS not in compliance with the CMS requirements is a finding.
    "
    desc 'fix', "Amend any system documentation requiring revision. Update Kubernetes etcd manifest and namespace PPS configuration to comply with CMS requirements."

    describe "Manually confirm Kubernetes etcd enforces ports, protocols, and services (PPS) that adhere to CMS requirements" do
      skip "Manually confirm Kubernetes etcd enforces ports, protocols, and services (PPS) that adhere to CMS requirements" 
    end
  end

end
