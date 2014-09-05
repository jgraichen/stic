module FileFixtures
  def fixture_base(base = nil)
    self.fixture_base = base if base
    Thread.current[:fixture_base]
  end

  def fixture_base=(base)
    Thread.current[:fixture_base] = base
  end

  def within_fixture_base(base)
    self.fixture_base = base
    yield
  ensure
    self.fixture_base = nil
  end

  def within_temporary_fixture_base(&block)
    Dir.mktmpdir do |dir|
      within_fixture_base dir, &block
    end
  end

  def within_fixture(path)
    raise ArgumentError, "No fixture base set." unless fixture_base

    chdir = fixture_path(path)
    raise ArgumentError, "Within fixture path does not point to directory: #{chdir}" unless File.directory?(chdir)

    Dir.chdir(chdir) { yield }
  end

  def fixture_path(path = '', base = nil)
    raise ArgumentError, "No fixture base set." unless fixture_base || base

    fixture_dir = File.expand_path("../../fixtures/#{base ? base : fixture_base}", __FILE__)
    return File.expand_path("./#{path}", fixture_dir)
  end
end

RSpec.configure do |c|
  c.include FileFixtures
  c.after(:each) { self.fixture_base = nil }
  c.after(:all) { FileUtils.rm_rf File.expand_path("../../fixtures", __FILE__) }
end
