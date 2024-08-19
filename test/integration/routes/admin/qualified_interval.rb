# frozen_string_literal: true

require "test_helper"

class AdminQualifiedIntervalsRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: "admin/qualified_intervals" }
  end

  test "routes qualified intervals within admin namespace" do
    assert_routing "/admin/qualified_intervals",
                   @defaults.merge(action: "index")

    assert_routing({ method: :post, path: "/admin/qualified_intervals" },
                   @defaults.merge(action: "create"))

    assert_routing "/admin/qualified_intervals/new",
                   @defaults.merge(action: "new")

    assert_routing "/admin/qualified_intervals/1/edit",
                   @defaults.merge(action: "edit", id: "1")

    assert_routing "/admin/qualified_intervals/1",
                   @defaults.merge(action: "show", id: "1")

    assert_routing({ method: :patch, path: "/admin/qualified_intervals/1" },
                   @defaults.merge(action: "update", id: "1"))

    assert_routing({ method: :delete, path: "/admin/qualified_intervals/1" },
                   @defaults.merge(action: "destroy", id: "1"))
  end
end
