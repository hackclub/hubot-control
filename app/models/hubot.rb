class Hubot < ActiveRecord::Base

  validates :name, uniqueness: true, presence: true
  validates :port, uniqueness: true, presence: true, numericality: true

  before_create :install
  before_destroy :uninstall

  def self.base_dir
    @@base_dir ||= Rails.root.join('hubots')
  end

  def output
    @output || ''
  end

  def log(val)
    @output = "#{output}#{val}"
  end

  def start_cmd(adapter = 'shell')
    "cd #{self.location} && PORT=#{self.port} bin/hubot -a #{adapter}"
  end

  def to_s
    name
  end

  private

    def install
      self.location = File.join(Hubot.base_dir, name.parameterize)
      log `hubot --create #{self.location}`
      log `cd #{self.location} && bin/hubot -v`
    end

    def uninstall
      log `rm -rf #{self.location}`
    end
end