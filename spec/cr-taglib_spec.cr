require "./spec_helper"

if !File.exists?("Vibe_Shakedown.mp3")
	`wget http://ipfs.io/ipfs/Qmca36xtguFaAGUhaBFqar1zCFRXQLcdeKBgwG8fGLLy9y -O Vibe_Shakedown.mp3` 
end
`cp Vibe_Shakedown.mp3 test.mp3`

describe TagLib do
	it "Reports file not existing" do
		expect_raises(Errno) do
			TagLib::MPEG::File.new("dne.mp3") {|f|
				f.tag.title
			}
		end
	end
	it "reads a file's length" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.audio_properties.length.should eq(211)
		}
	end
	it "reads a file's bitrate" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.audio_properties.bitrate.should eq(162)
		}
	end
	it "reads a file's samplerate" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.audio_properties.samplerate.should eq(44100)
		}
	end
	it "reads a file's channel count" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.audio_properties.channels.should eq(2)
		}
	end

	it "reads a file's title" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.title.should eq("Vibe")
		}
	end
	it "reads a file's artist" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.artist.should eq("Sequential Vibe")
		}
	end
	it "reads a file's album" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.album.should eq("")
		}
	end
	it "reads a file's comment" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.comment.should eq("http://sequentialvibecanada.blogspot.ca/")
		}
	end
	it "reads a file's genre" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.genre.should eq("")
		}
	end
	it "reads a file's year" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.year.should eq(0)
		}
	end
	it "reads a file's track" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.track.should( eq(0) || eq(1) )
		}
	end


	it "sets a file's title" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.title = "Vibe Shakedown"
			f.tag.title.should eq("Vibe Shakedown")
			f.save
		}
	end
	it "saves then reads a file's title" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.title.should eq("Vibe Shakedown")
			f.save
		}
	end
	it "sets a file's artist" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.artist = "SequentialVibe"
			f.tag.artist.should eq("SequentialVibe")
			f.save
		}
	end
	it "saves then reads a file's title" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.artist.should eq("SequentialVibe")
			f.save
		}
	end
	it "sets a file's album" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.album = "DSound"
			f.tag.album.should eq("DSound")
			f.save
		}
	end
	it "saves then reads a file's title" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.album.should eq("DSound")
			f.save
		}
	end

	it "sets a file's track" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.track = 1
			f.tag.track.should eq(1)
			f.save
		}
	end
	it "saves then reads a file's track" do
		TagLib::MPEG::File.new("test.mp3") {|f|
			f.tag.track.should eq(1)
			f.save
		}
	end

	it "works" do
		false.should eq(true)
	end
end
