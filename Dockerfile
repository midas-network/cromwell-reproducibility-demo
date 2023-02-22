FROM continuumio/miniconda3 as builder
WORKDIR /app
COPY environment.yml .
RUN conda env create -f environment.yml

FROM adoptopenjdk/openjdk15
COPY --from=builder /opt/conda/envs/seirs-conda /opt/conda/envs/seirs-conda
WORKDIR /app
# Python program to run in the container
COPY run_model.py .
COPY cromwell-84.jar .
COPY myWorkflow.wdl .
COPY inputs.json .
ENV PATH="$PATH:/opt/conda/envs/seirs-conda/bin"
ENTRYPOINT ["java", "-jar", "cromwell-84.jar", "run", "myWorkflow.wdl", "-i", "inputs.json"]
