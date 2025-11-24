all:
	docker build -t repro-25 .
	docker run -v ../../data/CrowdstormingDataJuly1st.csv:/analysis/crowdstorming.csv repro-25