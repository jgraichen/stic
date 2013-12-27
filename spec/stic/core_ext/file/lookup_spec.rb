require "spec_helper"

describe File do
  describe ".lookup" do
    before do
      FakeFS::FileSystem.chdir '/'
      FakeFS::FileSystem.add '/a/b/c/d/'
      FakeFS::FileSystem.add '/a/b/c/config.yaml', FakeFS::FakeFile.new
      FakeFS::FileSystem.add '/a/b/test.text', FakeFS::FakeFile.new
      FakeFS::FileSystem.add '/a/config.yml', FakeFS::FakeFile.new
      FakeFS::FileSystem.add '/a/test.txt', FakeFS::FakeFile.new
      FakeFS::FileSystem.add '/config.yaml', FakeFS::FakeFile.new
    end

    context "with filename" do
      it "should find file in current directory" do
        Dir.chdir("/a") do
          expect(File.lookup("test.txt")).to eq '/a/test.txt'
        end
      end

      it "should find file in parent directory" do
        Dir.chdir("/a/b") do
          expect(File.lookup("test.txt")).to eq '/a/test.txt'
        end
      end

      it "should find file in ancestor directory" do
        Dir.chdir("/a/b/c/d") do
          expect(File.lookup("test.txt")).to eq '/a/test.txt'
        end
      end

      it "should find first file in ancestor directory" do
        Dir.chdir("/a/b/c/d") do
          expect(File.lookup("config.yaml")).to eq '/a/b/c/config.yaml'
        end
      end
    end

    context "with regexp" do
      it "should find file in current directory" do
        Dir.chdir("/a") do
          expect(File.lookup(/^test\.txt$/)).to eq '/a/test.txt'
        end
      end

      it "should find file in parent directory" do
        Dir.chdir("/a/b") do
          expect(File.lookup(/^test\.txt$/)).to eq '/a/test.txt'
        end
      end

      it "should find file in ancestor directory" do
        Dir.chdir("/a/b/c/d") do
          expect(File.lookup(/^test\.txt$/)).to eq '/a/test.txt'
        end
      end

      it "should find first file in ancestor directory" do
        Dir.chdir("/a/b/c/d") do
          expect(File.lookup(/^config\.yaml$/)).to eq '/a/b/c/config.yaml'
        end
      end

      it "should find first file that match" do
        Dir.chdir("/a/b/") do
          expect(File.lookup(/^config\.ya?ml$/)).to eq '/a/config.yml'
        end
      end
    end

    context "with directory given" do
      context "with filename" do
        it "should find file" do
          expect(File.lookup("test.txt", '/a/b/c')).to eq '/a/test.txt'
        end
      end

      context "with regexp" do
        it "should find file" do
          expect(File.lookup(/^config\.ya?ml$/, '/a/b')).to eq '/a/config.yml'
        end
      end
    end
  end
end
