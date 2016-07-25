# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160725063241) do

  create_table "diagrams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "diagrammable_id"
    t.string   "diagrammable_type"
    t.text     "layout",            limit: 65535
    t.integer  "tenant_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["tenant_id"], name: "index_diagrams_on_tenant_id", using: :btree
  end

  create_table "kpis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "code"
    t.text     "description",  limit: 65535
    t.integer  "round"
    t.integer  "direction"
    t.integer  "unit"
    t.string   "unit_string"
    t.text     "formula_text", limit: 65535
    t.boolean  "is_system"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["code"], name: "index_kpis_on_code", using: :btree
  end

  create_table "node_sets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "diagram_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "tenant_id"
    t.index ["diagram_id"], name: "index_node_sets_on_diagram_id", using: :btree
    t.index ["tenant_id"], name: "index_node_sets_on_tenant_id", using: :btree
  end

  create_table "nodes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "type"
    t.string   "name"
    t.string   "code"
    t.string   "uuid"
    t.string   "devise_code"
    t.boolean  "is_selected", default: false
    t.integer  "node_set_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "ancestry"
    t.integer  "tenant_id"
    t.index ["ancestry"], name: "index_nodes_on_ancestry", using: :btree
    t.index ["node_set_id"], name: "index_nodes_on_node_set_id", using: :btree
    t.index ["tenant_id"], name: "index_nodes_on_tenant_id", using: :btree
  end

  create_table "oauth_access_grants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "resource_owner_id",               null: false
    t.integer  "application_id",                  null: false
    t.string   "token",                           null: false
    t.integer  "expires_in",                      null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["application_id"], name: "fk_rails_b4b53e07b8", using: :btree
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "fk_rails_732cb83ab7", using: :btree
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                                    null: false
    t.string   "uid",                                     null: false
    t.string   "secret",                                  null: false
    t.text     "redirect_uri", limit: 65535,              null: false
    t.string   "scopes",                     default: "", null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "owner_id"
    t.string   "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "project_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "tenant_id"
    t.integer  "project_id"
    t.integer  "rank"
    t.integer  "status"
    t.integer  "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_items_on_project_id", using: :btree
    t.index ["rank"], name: "index_project_items_on_rank", using: :btree
    t.index ["source_id"], name: "index_project_items_on_source_id", using: :btree
    t.index ["status"], name: "index_project_items_on_status", using: :btree
    t.index ["tenant_id"], name: "index_project_items_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_project_items_on_user_id", using: :btree
  end

  create_table "project_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "tenant_id"
    t.integer  "role",       default: 200
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["project_id"], name: "index_project_users_on_project_id", using: :btree
    t.index ["role"], name: "index_project_users_on_role", using: :btree
    t.index ["tenant_id"], name: "index_project_users_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_project_users_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "status",      default: 100
    t.integer  "tenant_id"
    t.string   "remark"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["tenant_id"], name: "index_projects_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "task_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_task_users_on_task_id", using: :btree
    t.index ["user_id"], name: "index_task_users_on_user_id", using: :btree
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.string   "content"
    t.string   "remark"
    t.integer  "user_id"
    t.integer  "type"
    t.integer  "status"
    t.string   "start_time"
    t.string   "end_time"
    t.datetime "due_time"
    t.integer  "taskable_id"
    t.string   "taskable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "result"
    t.index ["taskable_id"], name: "index_tasks_on_taskable_id", using: :btree
    t.index ["taskable_type"], name: "index_tasks_on_taskable_type", using: :btree
    t.index ["title"], name: "index_tasks_on_title", using: :btree
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "tenants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tenants_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "role"
    t.integer  "is_system",              default: 0
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "tenant_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["tenant_id"], name: "index_users_on_tenant_id", using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  add_foreign_key "diagrams", "tenants"
  add_foreign_key "node_sets", "diagrams"
  add_foreign_key "node_sets", "tenants"
  add_foreign_key "nodes", "node_sets"
  add_foreign_key "nodes", "tenants"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "project_items", "projects"
  add_foreign_key "project_items", "tenants"
  add_foreign_key "project_items", "users"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "tenants"
  add_foreign_key "project_users", "users"
  add_foreign_key "projects", "tenants"
  add_foreign_key "projects", "users"
  add_foreign_key "task_users", "tasks"
  add_foreign_key "task_users", "users"
  add_foreign_key "tasks", "users"
end
