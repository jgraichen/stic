module FileFixtures
  def fixture_base(base)
    @base = base
  end

  def within_fixture(path)
    raise ArgumentError, "No fixture base set." unless @base

    chdir = fixture_path(path)
    raise ArgumentError, "Within fixture path does not point to directory: #{chdir}" unless File.directory?(chdir)

    Dir.chdir(chdir) { yield }
  end

  def fixture_path(path)
    raise ArgumentError, "No fixture base set." unless @base

    fixture_dir = File.expand_path("../../fixtures/#{@base}", __FILE__)
    return File.expand_path("./#{path}", fixture_dir)
  end
end

RSpec.configure do |c|
  c.include FileFixtures
  c.after(:each) { fixture_base nil }
end
