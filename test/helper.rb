# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"
require "minitest/pride"
require "minitest/sugar"
require "ostruct"
require_relative "../lib/json_serializer"

User = OpenStruct
Organization = OpenStruct
Person = OpenStruct
Post = OpenStruct
