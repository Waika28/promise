defmodule MotivnationWeb.Schemas.UserResponse do
  use MotivnationWeb, :openapi_schema

  alias MotivnationWeb.Schemas.User

  OpenApiSpex.schema(%{
    title: "UserResponse",
    type: :object,
    properties: %{
      data: User
    }
  })
end
