{
  pkgs,
  config,
  ...
}: {
  programs.tmux = let
    tmuxConfFile = "${config.xdg.configHome}/tmux/tmux.conf";
    tmuxBatteryRepo = "${config.xdg.configHome}/tmux/tmux-battery";
  in {
    enable = true;
    # sensibleOnTop = true; # unable to set tmux default shell with sensible enabled
    terminal = "screen-256color";
    shell = "$SHELL";
    mouse = true;
    plugins = with pkgs; [
      tmuxPlugins.cpu
      tmuxPlugins.tmux-fzf
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '1' # minutes
        '';
      }
      {
        plugin = tmuxPlugins.battery;
        extraConfig = ''
          # clone the repo
          run-shell '[ -d ${tmuxBatteryRepo} ] || git clone https://github.com/tmux-plugins/tmux-battery ${tmuxBatteryRepo}'

          # see run-shell for tmux battery file at end of conf
        '';
      }
    ];
    extraConfig = ''
      set -g mouse on
      set -g status-left-length 30
      set -g status-right-length 80

      set -g status-interval 1
      set -g status-right '#H | #{battery_percentage}% #{battery_remain} | %Y-%m-%dT%H:%M:%S'

      bind r source-file "${tmuxConfFile}" \; display-message "tmux config reloaded"

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # docs say it has to be at the end of your tmux conf
      run-shell ${tmuxBatteryRepo}/battery.tmux
    '';
  };
}
