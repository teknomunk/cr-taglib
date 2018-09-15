# TODO: Write documentation for `Cr::Taglib`
module TagLib
	VERSION = "0.1.0"

	@[Link("tag_c")]
	lib Library
		struct File
			dummy : Int32
		end
		struct Tag
			dummy : Int32
		end
		struct AudioProperties
			dummy : Int32
		end
		enum FileType
			MPEG
			OggVorbis
			FLAC
			MPC
			OggFlac
			WavPack
			Speex
			TrueAudio	
			MP4
			ASF
			Type
		end

		fun taglib_free( ptr : Pointer(Void) ) : Void

		fun taglib_file_new( filename : UInt8* ) : Pointer(File)
		fun taglib_file_new_type( filename : UInt8*, type : FileType ) : Pointer(File)
		fun taglib_file_free( file : Pointer(File) ) : Void
		fun taglib_file_is_valid( file : Pointer(File) ) : Int32
		fun taglib_file_tag( file : Pointer(File) ) : Pointer(Tag)
		fun taglib_file_audioproperties( file : Pointer(File) ) : Pointer(AudioProperties)
		fun taglib_file_save( file : Pointer(File) ) : Int32

		fun taglib_tag_title( tag : Pointer(Tag) ) : UInt8*
		fun taglib_tag_artist( tag : Pointer(Tag) ) : UInt8*
		fun taglib_tag_album( tag : Pointer(Tag) ) : UInt8*
		fun taglib_tag_comment( tag : Pointer(Tag) ) : UInt8*
		fun taglib_tag_genre( tag : Pointer(Tag) ) : UInt8*
		fun taglib_tag_year( tag : Pointer(Tag) ) : UInt32
		fun taglib_tag_track( tag : Pointer(Tag) ) : UInt32

		fun taglib_tag_set_title( tag : Pointer(Tag), str : UInt8* ) : Void
		fun taglib_tag_set_artist( tag : Pointer(Tag), str : UInt8* ) : Void
		fun taglib_tag_set_album( tag : Pointer(Tag), str : UInt8* ) : Void
		fun taglib_tag_set_comment( tag : Pointer(Tag), str : UInt8* ) : Void
		fun taglib_tag_set_genre( tag : Pointer(Tag), str : UInt8* ) : Void
		fun taglib_tag_set_year( tag : Pointer(Tag), year : UInt32 ) : Void
		fun taglib_tag_set_track( tag : Pointer(Tag), track : UInt32 ) : Void
		fun taglib_tag_free_strings()

		fun taglib_audioproperties_length( ap : Pointer(AudioProperties) ) : Int32
		fun taglib_audioproperties_bitrate( ap : Pointer(AudioProperties) ) : Int32
		fun taglib_audioproperties_samplerate( ap : Pointer(AudioProperties) ) : Int32
		fun taglib_audioproperties_channels( ap : Pointer(AudioProperties) ) : Int32

		enum ID3v2_Encoding
			Latin1
			UTF16
			UTF16BE
			UTF8
			Encoding
		end

		fun taglib_id3v2_set_default_text_encoding( encoding : ID3v2_Encoding ) : Void
	end

	String = Library::ID3v2_Encoding

	class AudioProperties
		def initialize( @ptr : Pointer(Library::AudioProperties) )
		end
		{% for name in ["length","bitrate","samplerate","channels"] %}
			def {{name.id}}()
				Library.taglib_audioproperties_{{name.id}}( @ptr )
			end
		{% end %}
	end
	class Tag
		def initialize( @ptr : Pointer(Library::Tag) )
		end
		{% for name in ["title","artist","album","comment","genre"] %}
			def {{name.id}}
				::String.new( Library.taglib_tag_{{name.id}}( @ptr ) )
			end
			def {{name.id}}=( value : ::String )
				Library.taglib_tag_set_{{name.id}}( @ptr, value )
			end
		{% end %}
		{% for name in ["year","track"] %}
			def {{name.id}}
				Library.taglib_tag_{{name.id}}( @ptr )
			end
			def {{name.id}}=( value : Int32 )
				Library.taglib_tag_set_{{name.id}}( @ptr, value )
			end
		{% end %}
	end
	{% for filetype,e in {"MPEG"=>"MPEG","Ogg"=>"OggVorbis","MP4" => "MP4", "RIFF::Wav" => "WavPack", "FLAC" => "FLAC"} %}
		class {{filetype.id}}::File
			def initialize( filename : (::String) )
				raise Errno.new("No such file") if !::File.exists?(filename)
				@ptr = Library.taglib_file_new_type( filename, Library::FileType::{{e.id}} )
				yield self
			end
			def finalize()
				Library.taglib_file_free( @ptr )
			end
			def audio_properties()
				@ap ||= AudioProperties.new( Library.taglib_file_audioproperties( @ptr ) )
			end
			def tag()
				@tag ||= Tag.new( Library.taglib_file_tag( @ptr ) )
			end
			def save()
				Library.taglib_file_save( @ptr )
			end
		end
	{% end %}
end
