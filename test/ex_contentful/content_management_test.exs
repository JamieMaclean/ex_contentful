defmodule ExContentful.ContentManagementTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExContentful.ContentManagement

  test "Correctly retrieves the correct content type from an id" do
    use_cassette "content_type_migration" do
      ContentManagement.migrate_content_model()
    end
  end
end
