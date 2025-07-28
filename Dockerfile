name: Build and Push SNAP 12 Docker Image

on:
  push:
    branches: [main]  # or your branch name

jobs:
  build:
    runs-on: ubuntu-latest

    permissions:
      contents: read
      packages: write
      id-token: write

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up QEMU (for multi-arch, optional)
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository_owner }}/snap12:latest

      - name: Output image digest
        run: echo ${{ steps.build-and-push.outputs.digest }}
