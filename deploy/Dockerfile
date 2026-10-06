FROM flyway/flyway:11.20.3
WORKDIR /workspace
COPY . /workspace
ENTRYPOINT ["flyway", "-workingDirectory=/workspace", "-configFiles=/workspace/flyway.toml"]
CMD ["migrate"]
