terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.19.0"
    }
  }
}

provider "postgresql" {
  host            = "aws-0-eu-central-1.pooler.supabase.com"  
  port            = 5432         
  database        = var.db_name
  username        = var.db_username
  password        = var.db_password
  sslmode         = "require"     
  connect_timeout = 15
  superuser       = false
}



resource "null_resource" "create_extension" {
  provisioner "local-exec" {
    command = "psql --host=${var.db_host} --port=${var.db_port} --username=${var.db_username} --dbname=${var.db_name} --command \"CREATE EXTENSION IF NOT EXISTS vector;\""

    environment = {
      PGPASSWORD = var.db_password
    }
  }
}




resource "null_resource" "create_public_schema" {
  provisioner "local-exec" {
    command = "psql --host=${var.db_host} --port=${var.db_port} --username=${var.db_username} --dbname=${var.db_name} --command \"CREATE SCHEMA IF NOT EXISTS public;\""

    environment = {
      PGPASSWORD = var.db_password
    }
  }
}


resource "null_resource" "create_page_raw_table" {
  depends_on = [null_resource.create_public_schema]
  provisioner "local-exec" {
    command = <<EOT
    psql --host=${var.db_host} --port=${var.db_port} --username=${var.db_username} --dbname=${var.db_name} --command "
    CREATE TABLE IF NOT EXISTS public.page_raw (
        id TEXT PRIMARY KEY,
        url TEXT NOT NULL,
        last_updated TIMESTAMP NOT NULL,
        last_scraped TIMESTAMP NOT NULL,
        is_active BOOLEAN DEFAULT TRUE
    );"
    EOT

    environment = {
      PGPASSWORD = var.db_password
    }
  }
}


resource "null_resource" "create_page_content_table" {
  depends_on = [null_resource.create_public_schema]
  provisioner "local-exec" {
    command = <<EOT
    psql --host=${var.db_host} --port=${var.db_port} --username=${var.db_username} --dbname=${var.db_name} --command "
    CREATE TABLE IF NOT EXISTS public.page_content (
        id TEXT PRIMARY KEY,
        url TEXT NOT NULL,
        html_content TEXT,
        extracted_title TEXT,
        extracted_content TEXT,
        entities JSONB,
        is_active BOOLEAN DEFAULT TRUE,
        last_updated TIMESTAMP NOT NULL,
        last_scraped TIMESTAMP NOT NULL
    );"
    EOT

    environment = {
      PGPASSWORD = var.db_password
    }
  }
}

resource "null_resource" "create_page_keywords_table" {
  depends_on = [null_resource.create_public_schema]
  provisioner "local-exec" {
    command = <<EOT
    psql --host=${var.db_host} --port=${var.db_port} --username=${var.db_username} --dbname=${var.db_name} --command "
    CREATE TABLE IF NOT EXISTS public.page_keywords (
        id TEXT PRIMARY KEY,
        url TEXT NOT NULL,
        last_modified TIMESTAMP NOT NULL,
        tokenized_text TSVECTOR,
        raw_text TEXT,
        last_scraped TIMESTAMP NOT NULL
    );"
    EOT

    environment = {
      PGPASSWORD = var.db_password
    }
  }
}


resource "null_resource" "create_failed_jobs_table" {
  depends_on = [null_resource.create_public_schema]
  provisioner "local-exec" {
    command = <<EOT
    psql --host=${var.db_host} --port=${var.db_port} --username=${var.db_username} --dbname=${var.db_name} --command "
    CREATE TABLE IF NOT EXISTS public.failed_jobs (
        job_id SERIAL PRIMARY KEY,
        uid TEXT NOT NULL,
        job_type TEXT NOT NULL,
        error_message TEXT,
        failed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );"
    EOT

    environment = {
      PGPASSWORD = var.db_password
    }
  }
}

resource "null_resource" "create_page_embeddings_table" {
  depends_on = [null_resource.create_extension, null_resource.create_public_schema]
  provisioner "local-exec" {
    command = <<EOT
    psql --host=${var.db_host} --port=${var.db_port} --username=${var.db_username} --dbname=${var.db_name} --command "
    CREATE TABLE IF NOT EXISTS public.page_embeddings (
        id TEXT NOT NULL,
        split_id TEXT NOT NULL,
        url TEXT,
        chunk_text TEXT,
        embedding_vector VECTOR(1536),
        PRIMARY KEY (id, split_id),
        last_scraped TIMESTAMP NOT NULL
    );

    CREATE INDEX IF NOT EXISTS idx_page_embeddings_vector 
    ON public.page_embeddings 
    USING hnsw (embedding_vector vector_l2_ops);
    "
    EOT

    environment = {
      PGPASSWORD = var.db_password
    }
  }
}




resource "postgresql_schema" "public" {
  name  = "public"
}