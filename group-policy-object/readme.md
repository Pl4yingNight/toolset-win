# Group Policy Object (GPO)
GPOs configure clients and servers in a domain as defined in them.
They may include changes to User-Profiles, Firewall-Rules and many more.

## GPUpdate
GPUpdate can be used to force update the device it is launched on.

```batch
gpupdate /force
```

## GPResult
GPResult can be used to create a report on which GPOs are applied for a User on
a specific machine. For further information visit the official
<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/gpresult" target="_blank">Microsoft Info Page</a>.

```batch
gpresult /s cl1sr /user SR09\Administrator /h admin-gpos.html /f
```

## Enable Remote Management
> <a href="https://social.technet.microsoft.com/Forums/en-US/6fbf3994-1241-4657-8a4b-f504227c59fa/group-policy-error-quotthe-rpc-server-is-unavailablequot?forum=winserverGP" target="_blank">Source</a>

Following GPO is used to enable remote management on clients. This is the
simplest way to enable it on all clients in the linked Organisational Unit (OU).

Required by
+ GPUpdate when forcing a client to update
+ GPResult when running it for a client.

```
(Win-Server 2019)
Computer Configuration
 └ Policies
    └ Administrative Templates
       └ Network
          └ Network Connections
             └ Windows Defender Firewall
                └ Domain Profile
                   └ Windows Defender Firewall: Allow inbound remote administration exception
                      └> Enabled

```
