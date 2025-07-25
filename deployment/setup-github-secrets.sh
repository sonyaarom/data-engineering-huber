#!/bin/bash

echo "=== GitHub Secrets Setup Guide ==="
echo ""
echo "Required GitHub Secrets for deployment:"
echo ""

echo "1. HETZNER_HOST - Your server IP address"
echo "   Example: 123.456.789.012"
echo ""

echo "2. HETZNER_USER - SSH username (usually 'root' or your username)"
echo "   Example: root"
echo ""

echo "3. HETZNER_SSH_KEY - SSH private key (IMPORTANT: See format below)"
echo "   The SSH private key must be stored exactly as it appears in your .ssh file:"
echo "   - Include the full key from -----BEGIN to -----END"
echo "   - Preserve all line breaks"
echo "   - No extra spaces or characters"
echo ""
echo "   Example format:"
echo "   -----BEGIN OPENSSH PRIVATE KEY-----"
echo "   b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn"
echo "   [... key content ...]"
echo "   -----END OPENSSH PRIVATE KEY-----"
echo ""

echo "4. Database secrets:"
echo "   - DB_HOST"
echo "   - DB_PORT"
echo "   - DB_NAME"
echo "   - DB_USERNAME"
echo "   - DB_PASSWORD"
echo ""

echo "5. API Keys:"
echo "   - OPENAI_API_KEY"
echo "   - PINECONE_API_KEY"
echo "   - PINECONE_ENVIRONMENT"
echo "   - PINECONE_INDEX"
echo "   - TOGETHER_API_KEY"
echo ""

echo "6. Langfuse Configuration:"
echo "   - LANGFUSE_SECRET_KEY"
echo "   - LANGFUSE_PUBLIC_KEY"
echo ""

echo "7. Application Configuration:"
echo "   - SECRET_KEY"
echo "   - ADMIN_PASSWORD"
echo "   - SENTRY_DSN (optional)"
echo ""

echo "=== SSH Key Troubleshooting ==="
echo ""
echo "If you're getting 'error in libcrypto' errors:"
echo ""
echo "1. Generate a new SSH key pair on your local machine:"
echo "   ssh-keygen -t ed25519 -C 'github-actions-deploy'"
echo ""
echo "2. Add the PUBLIC key to your server's ~/.ssh/authorized_keys:"
echo "   ssh-copy-id -i ~/.ssh/id_ed25519.pub user@your-server"
echo ""
echo "3. Copy the PRIVATE key content to GitHub Secrets:"
echo "   cat ~/.ssh/id_ed25519"
echo "   (Copy the entire output including -----BEGIN and -----END lines)"
echo ""
echo "4. Test the key locally first:"
echo "   ssh -i ~/.ssh/id_ed25519 user@your-server"
echo ""

echo "=== Server Setup Requirements ==="
echo ""
echo "Your Hetzner server should have:"
echo "1. Docker and docker-compose installed"
echo "2. SSH access configured"
echo "3. Git installed (for cloning/updating the repository)"
echo "4. Proper firewall rules (port 1234 open for the application)"
echo "" 