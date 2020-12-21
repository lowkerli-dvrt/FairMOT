FROM pytorch/pytorch:1.2-cuda10.0-cudnn7-devel

RUN apt-get update && apt-get install -y \
        ffmpeg \
        git \
        curl \
    && rm -rf /var/lib/apt/lists/*

RUN cd $HOME \
    && git clone --single-branch \
        https://github.com/CharlesShang/DCNv2.git \
    && cd $HOME/DCNv2 \
    && ./make.sh

RUN mkdir /app
WORKDIR /app

COPY requirements.txt ./

RUN pip install --upgrade pip \
    && pip install Cython \
    && pip install -r requirements.txt \
    && rm -rf $HOME/.cache

RUN mkdir -p /root/.cache/torch/checkpoints/ \
    && curl -Lo /root/.cache/torch/checkpoints/dla34-ba72cf86.pth \
        http://dl.yf.io/dla/models/imagenet/dla34-ba72cf86.pth

COPY . .

CMD [ "python" ]
