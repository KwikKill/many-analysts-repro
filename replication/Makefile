all:
	docker build -t repro-team-0 .
	docker run -v $(shell pwd)/dataset/data/CrowdstormingDataJuly1st.csv:/app/dataset/data/CrowdstormingDataJuly1st.csv repro-team-0
