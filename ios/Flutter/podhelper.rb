# Install pods needed for Flutter plugins
def flutter_install_all_ios_pods(installer)
    require File.expand_path(File.join('..', 'Flutter', 'flutter_export_environment'), __FILE__)
    require File.expand_path(File.join('..', 'Flutter', 'generated_plugin_registrant'), __FILE__)
  end
  