ARG python_image_tag=3.9-slim

# --------------------
# -- COMPILER IMAGE --
# --------------------

FROM python:${python_image_tag} as compiler-image

# -- Layer: OS

RUN apt-get update -y && \
    pip3 install --upgrade pip

# -- Layer: Python

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY ./requirements.txt requirements.txt
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# -------------------
# -- BUILDER IMAGE --
# -------------------

FROM python:${python_image_tag} as builder-image

# -- Layer: Image Metadata

ARG build_date
LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.schema-version="1.0"

# -- Layer: Python

COPY --from=compiler-image /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# -- Runtime

RUN useradd -m -s /bin/bash user
USER user
WORKDIR /home/user

EXPOSE 8888
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
