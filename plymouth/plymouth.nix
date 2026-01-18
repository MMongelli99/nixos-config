{ pkgs, ... }:

{
  # Enable early KMS for Intel graphics so Plymouth can take over the display early
  boot.initrd.kernelModules = [ "i915" ];

  # Disable firmware splash to prevent Lenovo logo from showing
  boot.kernelParams = [ "quiet" "splash" "vt.global_cursor_default=0" "loglevel=3" "udev.log_level=3" ];

  boot.plymouth = {
    enable = true;
    theme = "x1-exploded";
    themePackages = [
      (pkgs.stdenv.mkDerivation {
        name = "plymouth-x1-exploded-theme";
        src = ./.;

        buildInputs = [ pkgs.plymouth ];

        installPhase = /* bash */ ''
          mkdir -p $out/share/plymouth/themes/x1-exploded
          cp ${./x1-exploded.png} $out/share/plymouth/themes/x1-exploded/x1-exploded.png

          cat > $out/share/plymouth/themes/x1-exploded/x1-exploded.plymouth <<EOF
          [Plymouth Theme]
          Name=X1 Exploded
          Description=X1 Exploded boot screen
          ModuleName=script

          [script]
          ImageDir=$out/share/plymouth/themes/x1-exploded
          ScriptFile=$out/share/plymouth/themes/x1-exploded/x1-exploded.script
          EOF

          cat > $out/share/plymouth/themes/x1-exploded/x1-exploded.script <<'EOF'
          # Set background to black
          Window.SetBackgroundTopColor(0, 0, 0);
          Window.SetBackgroundBottomColor(0, 0, 0);

          # Load the image
          logo.image = Image("x1-exploded.png");

          # Scale the image to fill the screen
          screen_width = Window.GetWidth();
          screen_height = Window.GetHeight();
          image_width = logo.image.GetWidth();
          image_height = logo.image.GetHeight();

          # Calculate scaling to fill screen while maintaining aspect ratio
          scale_x = screen_width / image_width;
          scale_y = screen_height / image_height;
          scale = Math.Max(scale_x, scale_y);

          # Create scaled sprite
          logo.sprite = Sprite(logo.image);
          logo.sprite.SetImage(logo.image.Scale(image_width * scale, image_height * scale));

          # Center the scaled image
          logo.sprite.SetX((screen_width - image_width * scale) / 2);
          logo.sprite.SetY((screen_height - image_height * scale) / 2);

          # Simple message handler
          fun message_callback (text) {
              # You can add text display here if desired
          }
          Plymouth.SetMessageFunction(message_callback);
          EOF
        '';
      })
    ];
  };
}
