defmodule ExAws.Bedrock.Nova.Content do
  @moduledoc """
  Constructor functions for dynamic content items (Text, Image, Video, Audio).
  """

  @doc "Text content item"
  def text(string) when is_binary(string), do: %{text: string}

  @doc "Image content item"
  def image(format, bytes_or_base64) when format in ~w(jpeg png gif webp) do
    %{
      image: %{
        format: format,
        source: %{bytes: bytes_or_base64}
      }
    }
  end

  @doc "Video content item via bytes/base64"
  def video_bytes(format, bytes_or_base64)
      when format in ~w(mkv mov mp4 webm three_gp flv mpeg mpg wmv) do
    %{
      video: %{
        format: format,
        source: %{bytes: bytes_or_base64}
      }
    }
  end

  @doc "Video content item via S3 Location"
  def video_s3(format, uri, bucket_owner \\ nil)
      when format in ~w(mkv mov mp4 webm three_gp flv mpeg mpg wmv) do
    s3_loc =
      %{uri: uri}
      |> then(fn map -> if bucket_owner, do: Map.put(map, :bucketOwner, bucket_owner), else: map end)

    %{
      video: %{
        format: format,
        source: %{s3Location: s3_loc}
      }
    }
  end

  @doc "Audio content item via bytes/base64"
  def audio_bytes(format, bytes_or_base64)
      when format in ~w(mp3 opus wav aac flac mp4 ogg mkv) do
    %{
      audio: %{
        format: format,
        source: %{bytes: bytes_or_base64}
      }
    }
  end

  @doc "Audio content item via S3 Location"
  def audio_s3(format, uri, bucket_owner \\ nil)
      when format in ~w(mp3 opus wav aac flac mp4 ogg mkv) do
    s3_loc =
      %{uri: uri}
      |> then(fn map -> if bucket_owner, do: Map.put(map, :bucketOwner, bucket_owner), else: map end)

    %{
      audio: %{
        format: format,
        source: %{s3Location: s3_loc}
      }
    }
  end
end