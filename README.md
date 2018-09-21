# Xsede-Throttle-Patch

### Warning: This program is experimental and still incomplete. Use at your own risk.

## What is Xsede?
Xsede is a background, low-resource utility to apply and enforce Intel Extreme Tuning Utility (XTU) settings.

## Why use Xsede instead of a task scheduler?
Often times, manufacturers will hard set package TDP dissapation, which can and do override the settings applied by XTU. This is particlarly prominent within laptops. Speaking from experience, my Lenovo X1 Carbon faces severe throttling, and actively works against XTU modifications. Xsede utilizes a smart algorithm to detect when the internal Embedded Controller reverts the values, and also reapplies the XTU settings.

However, Xsede also has uses outside of buildin strict OEM TDP rules. Xsede brings reliability, customizability, and ease of use that a simple task scheduler cannot bring.

## What features are in Xsede?
- Automatic backend XTU launching
- Customizable XTU settings (profile support planned)
- Battery mode and AC autodetection and profiles for optimizing battery life and performance
- Override OEM TDP limits

## So how do I get started?
The current version lacks significant features or contain major bugs. After a stable release is made, this section will be updated. If you are still interested in trying Xsede or contibuting, clone te repository. You can right click "Xsede-Throttle-Patch.ps1" to either:

a) Run the script. **Warning: This program is experimental and still incomplete. Use at your own risk.** 

or

b) Edit the script. All customizable settings are at the top of the file.
