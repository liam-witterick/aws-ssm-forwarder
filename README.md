# aws-ssm-forwarder

A small CLI to open **AWS Systems Manager (SSM)** tunnels for:
- **Generic port forwarding** (`pf`) - to the EC2 instance itself, or to any **remote host** (e.g., an RDS endpoint) *via* the EC2.
- **SSH via SSM** (`ssh`) - open an SSM tunnel and SSH through it (no public :22 needed).

---

## Requirements

- AWS CLI v2
- `ssh` (for SSH subcommand)
- EC2 instance:
  - SSM Agent installed and running
  - Instance profile attached with `AmazonSSMManagedInstanceCore`
  - Network egress or VPC endpoints for `ssm`, `ssmmessages`, `ec2messages`

---

## Installation

```bash
git clone https://github.com/liam-witterick/aws-ssm-forwarder.git
cd aws-ssm-forwarder
make install

# Or manual install:
chmod +x bin/ssm-tunnel
cp bin/ssm-tunnel /usr/local/bin
```

---

## Usage

The CLI uses subcommands:

### Port Forward (pf)
Forward a local port to an EC2 instance (or remote host via the instance).

```bash
ssm-tunnel pf -i <INSTANCE_ID> [-r <REMOTE_PORT>] [-L <LOCAL_PORT>] [--remote-host <HOST>] [--profile <PROFILE>] [--region <REGION>] [--print-port]
```

- `-i, --instance <id>`: EC2 instance ID (**required**)
- `-r, --remote-port <port>`: Remote port to forward (default: 22)
- `-L, --local-port <port>`: Local port to bind (default: random)
- `--remote-host <host>`: Forward to a remote host (e.g., RDS endpoint) via the instance
- `--profile <profile>`: AWS CLI profile
- `--region <region>`: AWS region
- `--print-port`: Print the chosen local port to stdout (for scripting)

#### Example: Forward local 8080 to instance's port 80
```bash
ssm-tunnel pf -i i-0123456789abcdef0 -r 80 -L 8080
```

#### Example: Forward local 5432 to RDS via jump host
```bash
ssm-tunnel pf -i i-0123456789abcdef0 -r 5432 -L 5432 --remote-host mydb.abc123.eu-west-1.rds.amazonaws.com
```

---

### SSH (ssh)
Port-forward to instance:22 and SSH through the tunnel.

```bash
ssm-tunnel ssh -i <INSTANCE_ID> -u <USER> [-k <KEY>] [-L <LOCAL_PORT>] [--profile <PROFILE>] [--region <REGION>] [-- ...ssh args]
```

- `-i, --instance <id>`: EC2 instance ID (**required**)
- `-u, --user <username>`: SSH user (**required**)
- `-k, --key <path>`: Path to SSH private key
- `-L, --local-port <port>`: Local port to bind (default: random)
- `--profile <profile>`: AWS CLI profile
- `--region <region>`: AWS region
- `--`: Pass extra arguments to SSH

#### Example: SSH to instance
```bash
ssm-tunnel ssh -i i-0123456789abcdef0 -u ec2-user -k ~/.ssh/key.pem
```

#### Example: SSH with custom port and additional command to shell
```bash
ssm-tunnel ssh -i i-0123456789abcdef0 -u ubuntu -k ~/.ssh/my-key.pem -L 2222 -- ls -la
```

---

## Notes
- Region precedence: `--region` > profile's region > `AWS_REGION`/`AWS_DEFAULT_REGION`
- For more, run `ssm-tunnel --help` or see the script's usage output.