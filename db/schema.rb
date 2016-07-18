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

ActiveRecord::Schema.define(version: 20160718041045) do

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
    t.boolean  "is_selected"
    t.integer  "node_set_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "ancestry"
    t.integer  "tenant_id"
    t.index ["ancestry"], name: "index_nodes_on_ancestry", using: :btree
    t.index ["node_set_id"], name: "index_nodes_on_node_set_id", using: :btree
    t.index ["tenant_id"], name: "index_nodes_on_tenant_id", using: :btree
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
    t.index ["tenant_id"], name: "index_project_items_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_project_items_on_user_id", using: :btree
  end

  create_table "project_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "tenant_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "role",       default: 200
    t.index ["project_id"], name: "index_project_users_on_project_id", using: :btree
    t.index ["tenant_id"], name: "index_project_users_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_project_users_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.string   "status",      default: "100"
    t.integer  "tenant_id"
    t.string   "remark"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["tenant_id"], name: "index_projects_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
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
    t.string   "due_time"
    t.integer  "taskable_id"
    t.string   "taskable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "time_span"
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
  add_foreign_key "project_items", "projects"
  add_foreign_key "project_items", "tenants"
  add_foreign_key "project_items", "users"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "tenants"
  add_foreign_key "project_users", "users"
  add_foreign_key "projects", "tenants"
  add_foreign_key "projects", "users"
  add_foreign_key "tasks", "users"
end
