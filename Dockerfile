FROM ubuntu:22.04 AS prod

LABEL maintainer="tkosht <takehito.oshita.business@gmail.com>"

ENV TZ Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get --fix-missing install -y sudo build-essential autoconf cmake \
        curl nodejs npm default-jre unzip tzdata locales dialog \
        libgeos-dev libsnappy-dev fontconfig fonts-ipaexfont fonts-ipafont \
        libopenmpi-dev \
        libmecab-dev mecab mecab-ipadic-utf8 mecab-utils file \
    && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

#         vim tmux tzdata locales dialog git bash-completion jq sqlite3 \


# for google-chrome
# # driver and chrome browser
RUN apt-get install -y libgbm-dev x11vnc xvfb \
    && CHROMEDRIVER_VERSION=$(curl -sS https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE) \
    && curl -sSL -o /tmp/chromedriver-linux64.zip https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip \
    && cd /tmp && unzip chromedriver-linux64.zip && mv chromedriver-linux64/chromedriver /usr/local/bin/ \
    && curl -sSL -o /tmp/chrome-linux64.zip https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROMEDRIVER_VERSION/linux64/chrome-linux64.zip \
    && cd /tmp && unzip chrome-linux64.zip && mv chrome-linux64 /opt

ENV PATH $PATH:/opt/chrome-linux64

RUN apt-get --fix-missing install -y --no-install-recommends \
        python3.10 \
        python3.10-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel

RUN ln -s /usr/bin/python3.10 /usr/bin/python \
    && ln -s /usr/bin/pdb3 /usr/bin/pdb

ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8" \
    TZ="Asia/Tokyo" \
    TERM="xterm"

# ======================== #
# MeCab
WORKDIR /tmp

RUN python -m pip install --upgrade pip matplotlib

# upgrade system
RUN apt-get upgrade -y \
    && apt-get autoremove -y \
    && apt-get clean -y
    # && rm -rf /var/lib/apt/lists/*

# setup general user
ARG user_id=1000
ARG group_id=1000
ARG user_name
ARG group_name

RUN groupadd --gid $group_id $group_name
RUN useradd -s /bin/bash --uid $user_id \
    --gid $group_id -m $user_name
ARG home_dir=/home/$user_name

RUN echo $user_name:$user_name | chpasswd
RUN echo $user_name ALL=\(root\) NOPASSWD:ALL \
    > /etc/sudoers.d/$user_name\
    && chmod 0440 /etc/sudoers.d/$user_name

RUN chown -R $user_name:$group_name $home_dir 
USER $user_name

# Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog


# ==========
FROM prod AS dev
LABEL maintainer="tkosht <takehito.oshita.business@gmail.com>"
RUN sudo apt-get --fix-missing install -y \
        vim tmux git jq sqlite3

#         libgeos-dev libsnappy-dev fontconfig fonts-ipaexfont fonts-ipafont \
#         libopenmpi-dev

