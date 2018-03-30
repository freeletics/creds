require "test_helper"

class ActiveCredentialsTest < Minitest::Test
  def test_version_number
    refute_nil ActiveCredentials::VERSION
  end

  def test_encrypted_file
    credentials = ActiveCredentials.new(
      "test/fixtures/credentials.yml.enc",
      key_path: "test/fixtures/master.key"
    )
    assert_equal "El Barto", credentials.artist
    assert_equal "El Barto", credentials.artist!
  end

  def test_plain_text_file
    credentials = ActiveCredentials.new(
      "test/fixtures/credentials-plain.yml",
      env: "test"
    )
    assert_equal "Bart", credentials.artist
    assert_equal "Bart", credentials.artist!
  end

  def test_encrypted_file_raises_error_on_missing_key_with_bang
    credentials = ActiveCredentials.new(
      "test/fixtures/credentials.yml.enc",
      key_path: "test/fixtures/master.key"
    )
    assert_raises(KeyError) do
      credentials.who!
    end
  end

  def test_plain_text_file_raises_error_on_missing_key_with_bang
    credentials = ActiveCredentials.new(
      "test/fixtures/credentials-plain.yml",
      env: "test"
    )
    assert_raises(KeyError) do
      credentials.who!
    end
  end

  def test_encrypted_file_returns_config_as_hash
    credentials = ActiveCredentials.new(
      "test/fixtures/credentials.yml.enc",
      key_path: "test/fixtures/master.key"
    )
    assert_equal({artist: "El Barto", secret_key_base: "secret-key-base"}, credentials.configuration.config)
  end

  def test_plain_text_file_returns_config_as_hash
    credentials = ActiveCredentials.new(
      "test/fixtures/credentials-plain.yml",
      env: "test"
    )
    assert_equal({artist: "Bart", embeded: 3}, credentials.configuration.config)
  end

  def test_plain_test_allows_to_embed_ruby
    credentials = ActiveCredentials.new(
      "test/fixtures/credentials-plain.yml",
      env: "test"
    )

    assert_equal 3, credentials.embeded
  end
end
