defmodule Content.ContentManagemnet.ContentTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Content.Integration.Content.ContentManagement

  setup_all do
    start_supervised!(Content.Integration.Content)
    :ok
  end

  test "Correctly retrieves the correct content type from an id" do
    use_cassette "content_type_migration" do
      ContentManagement.migrate_content_model()
    end
  end
end
