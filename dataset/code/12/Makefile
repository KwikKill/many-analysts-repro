all:
	docker build -t repro-12 .
	docker run -v ../../data/CrowdstormingDataJuly1st.csv:/analysis/crowdstorming.csv repro-12