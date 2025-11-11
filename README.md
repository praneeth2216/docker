# Practice Docker container: Python + Flask

This is a minimal example to practice building and running a container locally.

Files added:
- `Dockerfile` — builds a small image with the Flask app
- `app.py` — minimal Flask app listening on port 5000
- `requirements.txt` — pinned dependency

Build and run (PowerShell):

```powershell
# Build the image (from repository root where the Dockerfile is located)
docker build -t flask-practice .

# Run the container and map port 5000 to the host
docker run --rm -p 5000:5000 flask-practice
```

Then open http://localhost:5000 in your browser. 

Notes:
- This Dockerfile uses `python:3.11-slim`. If you prefer a smaller runtime, consider using a multi-stage build or an alternative base image.
- To iterate during development with live reload, run the app locally with a virtualenv and `pip install -r requirements.txt` instead of using the container.
