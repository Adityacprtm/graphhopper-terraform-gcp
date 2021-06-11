variable "base_name" {
  description = "Base name of service"
  default     = "graphhopper"
}

variable "region" {
  description = "Set the region for managed instance and the other environment"
  default     = "asia-southeast2" // Jakarta
}

variable "graphhopper_startup_script" {
  type    = string
  default = <<EOF
  cd /home/ubuntu/graphhopper-3.0
  rm -rf /home/ubuntu/graphhopper-3.0/logs
  export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
  export JAVA_OPTS="-Xms10g -Xmx12g"
  sudo service nginx restart
  ./graphhopper.sh -a web -i asia_indonesia.pbf -c config.yml -d
  EOF
}
