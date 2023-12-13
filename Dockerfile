# This is a potassium-standard dockerfile, compatible with Banana
# Must use a Cuda version 11+
# FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

ARG TEST_BUILD_ARG
RUN if [ -z "${TEST_BUILD_ARG}" ]; then echo "TEST_BUILD_ARG not set" && exit 1; fi

ARG TEST_BUILD_ARG_2
RUN if [ -z "${TEST_BUILD_ARG_2}" ]; then echo "TEST_BUILD_ARG_2 not set" && exit 1; fi


WORKDIR /

# Install git
RUN apt-get update && apt-get install -y git

# Install python packages
RUN pip3 install --upgrade pip
ADD requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Add your model weight files 
# (in this case we have a python script)
ADD download.py .
RUN python3 download.py

ADD . .

EXPOSE 8000

CMD python3 -u app.py
