#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'open3'

class DotfilesSetup
  DEFAULT_PACKAGES = %w[ansible fish git].freeze
  DOTFILES_REPO = 'git@github.com:balazsmiklos85/dotfiles.git'

  def initialize
    @user = ENV.fetch('USER') { abort 'USER environment variable not set' }
    @hostname = `hostname`.strip
    @home_dir = ENV.fetch('HOME') { abort 'HOME environment variable not set' }
    @config_dir = File.join(@home_dir, '.config')
  end

  def run
    puts "🚀 Starting dotnet repository setup for #{@user}@#{@hostname}"

    install_packages
    change_shell
    setup_ssh_keys
    clone_repository
    setup_config_files
    run_system_update

    puts "\n✅ Setup complete! You may want to log out and back in to fully activate fish shell."
  end

  private

  def install_packages
    puts "\n📦 Installing required packages..."
    run_command("sudo zypper install --no-recommends #{DEFAULT_PACKAGES.join(' ')}",
                'Installing packages')
  end

  def change_shell
    puts "\n🐚 Changing default shell to fish..."
    fish_path = `which fish`.strip

    abort '❌ Fish not found in PATH' if fish_path.empty?

    puts "You'll need to enter your password to change the shell:"
    run_command("chsh -s #{fish_path} #{@user}", 'Changing default shell')
  end

  def setup_ssh_keys
    puts "\n🔑 Setting up SSH keys..."

    ssh_dir = File.join(@home_dir, '.ssh')
    private_key = File.join(ssh_dir, 'id_ed25519')
    public_key = "#{private_key}.pub"

    if File.exist?(private_key)
      puts "SSH key already exists at #{private_key}"
      return
    end

    FileUtils.mkdir_p(ssh_dir, mode: 0o700)

    email = "#{@user}@#{@hostname}"
    run_command(
      "ssh-keygen -t ed25519 -C '#{email}' -f #{private_key} -N ''",
      'Generating SSH key pair'
    )

    return unless File.exist?(public_key)

    puts <<~MESSAGE
      📋 Your public key:
      #{'=' * 60}
      #{File.read(public_key).strip}
      #{'=' * 60}

      🌐 Please add this key to GitHub: https://github.com/settings/keys
      Press Enter when you've added the key to continue...
    MESSAGE
    $stdin.gets
  end

  def clone_repository
    puts "\n📥 Cloning repository..."

    dotfiles_dir = File.join(@home_dir, 'dotfiles')

    if Dir.exist?(dotfiles_dir)
      puts "Repository already exists at #{dotfiles_dir}, removing it first..."
      FileUtils.rm_rf(dotfiles_dir)
    end

    # Test SSH connection first
    puts 'Testing SSH connection to GitHub...'
    output, status = Open3.capture2e('ssh -T git@github.com 2>&1')

    unless status.success? || output.include?('successfully authenticated')
      abort "❌ SSH connection to GitHub failed. Please make sure you've added your SSH key.\nTest with: ssh -T git@github.com"
    end

    run_command(
      "git clone #{DOTFILES_REPO}",
      'Cloning repository via SSH'
    )
  end

  def setup_config_files
    puts "\n📁 Setting up config files..."

    dotfiles_dir = File.join(@home_dir, 'dotfiles')

    abort '❌ Dotfiles directory not found.' unless Dir.exist?(dotfiles_dir)

    # Create .config directory if it doesn't exist
    FileUtils.mkdir_p(@config_dir)

    # Use rsync to copy files
    run_command(
      "rsync -av #{dotfiles_dir}/ #{@config_dir}/",
      'Copying dotfiles to ~/.config'
    )

    # Clean up the original dotfiles directory
    puts "Cleaning up #{dotfiles_dir}"
    FileUtils.rm_rf(dotfiles_dir)
  end

  def run_system_update
    puts "\n🔄 Running system-update..."

    # Try to run system-update with fish
    system_update_script = File.join(@config_dir, 'fish', 'functions', 'system-update.fish')

    if File.exist?(system_update_script)
      fish_path = `which fish`.strip
      run_command("#{fish_path} -c 'system-update'", 'Running system-update')
    else
      puts '⚠️  system-update script not found at expected location'
      puts "You may need to run 'system-update' manually after logging back in"
    end
  end

  def run_command(command, description)
    puts "Running: #{description}"

    success = system(command)

    if success
      puts "✅ #{description} completed successfully"
    else
      abort "❌ #{description} failed"
    end
  end
end

# Run the setup if this script is executed directly
if $PROGRAM_NAME == __FILE__
  begin
    setup = DotfilesSetup.new
    setup.run
  rescue Interrupt
    abort "\n\n❌ Setup cancelled by user"
  rescue StandardError => e
    abort "\n❌ Error occurred: #{e.message}#{e.backtrace if ENV['DEBUG']}"
  end
end
