packer {
  required_plugins {
    docker = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "docker_source" {
  type    = string
  default = ""
}

variable "tmp_dir" {
  type    = string
  default = "/tmp/{{project_id}}"
}

variable "version" {
  type    = string
  default = "x.x.x"
}

source "docker" "studio" {
  image  = var.docker_source
  commit = true
  run_command = [
    "--privileged",
    "-e",
    "container=docker",
    "-v",
    "/sys/fs/cgroup:/sys/fs/cgroup",
    "-d",
    "-i",
    "-t",
    "\{{.Image}}",
  ]
  changes = [
    "ENV LANG en_US.UTF-8",
    "ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    "ENTRYPOINT [\"{{project_id}}\"]",
    "CMD []"
  ]
}

build {
  sources = [
    "source.docker.studio"
  ]

  name = "studio"

  provisioner "shell" {
    inline = [
      "mkdir -p ${var.tmp_dir}"
    ]
  }

  provisioner "shell" {
    script = "provisioners/shell/init.sh"
  }

  provisioner "ansible-local" {
    playbook_file = "provisioners/ansible/{{project_id}}.yaml"
    group_vars = "conf/ansible/"
    inventory_groups = ["defaults"]
  }

  provisioner "shell" {
    script = "provisioners/shell/info.sh"
  }

  post-processor "docker-tag" {
    repository = "{{github_id}}/{{project_id}}"
    tags        = [
      "latest",
      var.version
    ]
  }
}
