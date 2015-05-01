# ansible-mesos

An Ansible role for installing [Apache Mesos](http://mesos.apache.org).

## Role Variables

- `mesos_version` - Mesos version.
- `mesos_conf_dir` - Primary configuration for Mesos (default: `/etc/mesos`)
- `mesos_leader` - Flag to determine if a node is a Mesos leader (default: `False`)
- `mesos_leader_conf_dir` - Configuration directory for Mesos leaders (default: `/etc/mesos-master`)
- `mesos_leader_cluster` - Mesos cluster name (default: `mesos-cluster`)
- `mesos_leader_quorum` - Quorum value for replicated log based registry (default: `2`)
- `mesos_follower_conf_dir` Configuration directory for Mesos followers (`/etc/mesos-slave`)

## Example Playbook

See the [examples](./examples/) directory.
