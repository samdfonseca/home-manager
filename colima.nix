{ pkgs, ... }:

{
  home.packages = [
    pkgs.colima
    pkgs.docker-client
    pkgs.kubectl
    pkgs.kubernetes-helm
  ];

  # Colima "k8s" profile configuration
  # Start with: colima start --profile k8s
  home.file.".colima/k8s/colima.yaml".text = ''
    # Number of CPUs to allocate
    cpu: 4

    # Memory in GiB
    memory: 8

    # Disk size in GiB
    disk: 60

    # Container runtime: docker, containerd
    runtime: docker

    # Enable Kubernetes
    kubernetes:
      enabled: true

    # VM type: qemu
    vmType: qemu

    # Architecture
    arch: x86_64

    # Network configuration
    network:
      # Enable port forwarding from guest to host
      address: true
      dns: []
      dnsHosts: {}

    # Forward additional ports from the VM to the host
    forwardAgent: false

    # Docker daemon configuration
    docker: {}

    # Provision scripts (run on VM start)
    provision: []

    # SSH agent forwarding
    sshConfig: true

    # Mount type for volumes
    mountType: sshfs

    # Volumes to mount
    mounts: []

    # Environment variables for the VM
    env: {}
  '';
}
