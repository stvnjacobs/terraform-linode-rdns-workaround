# terraform-linode-rdns-workaround

**Problem:** The Linode API checks that a forward DNS record exists when setting
a reverse DNS record for an IP address. If managing the DNS records using
Terraform, the API request to update rDNS will not wait for the new forward DNS
changes to be propagated.

## Usage

An existing domain is required. This is just for example purposes, and the
example fails if there is no existing domain.

``` sh
# init project
terrorm init

# domain must already exist on account for this example.
terraform apply -var 'domain=example.com'

# wait time is configurable
terraform apply -var 'domain=example.com' -var 'wait_for=5m'
```

## How it works

On changes to a Linode's DNS record, wait enough time for propagation (10
minutes by default), then

## Future work

There is an open pull request to render this hack obsolete. It is much smarter,
as it will retry the API call until it succeeds, rather than blindly waiting.

https://github.com/linode/terraform-provider-linode/pull/570
