from subprocess import Popen
import os


export_folder = "../releases/rememory-gwj16"
version = "0.1.0"
version_folder = "{}/{}".format(export_folder, version)
if not os.path.exists(version_folder):
    os.mkdir(version_folder)

windows_folder, linux_folder, html_folder = ["{}/{}".format(version_folder, directory) for directory in ["windows", "linux", "html"]]
for folder in [windows_folder, linux_folder, html_folder]:
    if not os.path.exists(folder):
        os.mkdir(folder)

print(windows_folder, linux_folder, html_folder)
# godot_path = "/home/laurent/Downloads/Godot_v3.2-beta3_x11.64"
godot_path = "/home/laurent/.local/share/Steam/steamapps/common/Godot Engine/godot.x11.opt.tools.64"
windows_build = Popen([
    godot_path, "--export", "Windows Desktop", windows_folder + "/ReMemory{}.exe".format(version)])


linux_build = Popen([
    godot_path, "--export", "Linux/X11", linux_folder + "/ReMemory{}.x86_64".format(version)])



html_build = Popen([
    godot_path, "--export", "HTML5", html_folder + "/index.html"])

windows_build.communicate()
linux_build.communicate()
html_build.communicate()

Popen(["chmod", "+x", linux_folder + "/ReMemory{}.x86_64".format(version)])

windows_upload = Popen(["butler", "push", windows_folder, "willowblade/re-memory:win", "--userversion", version])
windows_upload.communicate()

linux_upload = Popen(["butler", "push", linux_folder, "willowblade/re-memory:linux", "--userversion", version])
linux_upload.communicate()

html_upload = Popen(["butler", "push", html_folder, "willowblade/re-memory:html", "--userversion", version])
html_upload.communicate()