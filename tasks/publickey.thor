class Publickey < GhTools
  desc 'add', 'Add a public key from a file'
  method_options file: :string
  def add
    key = File.read(File.expand_path(options.file))
    octokit.add_key(nil, key)
  end
end
