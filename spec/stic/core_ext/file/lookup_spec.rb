require "spec_helper"

describe File do
  describe ".lookup" do
    around { |example| within_fixture_base 'lookup1', &example }

    context "with filename" do
      it "should find file in current directory" do
        within_fixture("/a") do
          expect(File.lookup("test.txt")).to eq fixture_path '/a/test.txt'
        end
      end

      it "should find file in parent directory" do
        within_fixture("/a/b") do
          expect(File.lookup("test.txt")).to eq fixture_path '/a/test.txt'
        end
      end

      it "should find file in ancestor directory" do
        within_fixture("/a/b/c/d") do
          expect(File.lookup("test.txt")).to eq fixture_path '/a/test.txt'
        end
      end

      it "should find first file in ancestor directory" do
        within_fixture("/a/b/c/d") do
          expect(File.lookup("config.yaml")).to eq fixture_path '/a/b/c/config.yaml'
        end
      end
    end

    context "with regexp" do
      it "should find file in current directory" do
        within_fixture("/a") do
          expect(File.lookup(/^test\.txt$/)).to eq fixture_path '/a/test.txt'
        end
      end

      it "should find file in parent directory" do
        within_fixture("/a/b") do
          expect(File.lookup(/^test\.txt$/)).to eq fixture_path '/a/test.txt'
        end
      end

      it "should find file in ancestor directory" do
        within_fixture("/a/b/c/d") do
          expect(File.lookup(/^test\.txt$/)).to eq fixture_path '/a/test.txt'
        end
      end

      it "should find first file in ancestor directory" do
        within_fixture("/a/b/c/d") do
          expect(File.lookup(/^config\.yaml$/)).to eq fixture_path '/a/b/c/config.yaml'
        end
      end

      it "should find first file that match" do
        within_fixture("/a/b/") do
          expect(File.lookup(/^config\.ya?ml$/)).to eq fixture_path '/a/config.yml'
        end
      end
    end

    context "with directory given" do
      context "with filename" do
        it "should find file" do
          expect(File.lookup("test.txt", fixture_path('/a/b/c'))).to eq fixture_path '/a/test.txt'
        end
      end

      context "with regexp" do
        it "should find file" do
          expect(File.lookup(/^config\.ya?ml$/, fixture_path('/a/b'))).to eq fixture_path '/a/config.yml'
        end
      end
    end
  end
end
