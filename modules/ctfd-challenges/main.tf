terraform {
  required_providers {

    ctfd = {
      source = "ctfer-io/ctfd"
      version = "1.0.0"
    }
  }
}

provider "ctfd" {
  url = "https://ts2024.ctfd.sjors.people.aws.dev"

}

resource "ctfd_challenge" "challenge1" {
  name = "challenge 1"
  category = "challenge 1 category"
  description = "hello"
  value = 500
  state = "visible"
  topics = ["topic1", "topic2"]

}

resource "ctfd_challenge" "challenge3" {
  name = "challenge 3"
  category = "challenge 3 category"
  description = "hello hello!"
  value = 500
  state = "visible"
  topics = ["topic1", "topic2"]

}

resource "ctfd_flag" "flag1" {
  challenge_id = ctfd_challenge.challenge1.id
  content = "someflag"
}

resource "ctfd_challenge" "challenge2" {
  name = "challenge 1"
  category = "challenge 1 category"
  description = "hello"
  value = 500
  state = "visible"
  requirements = {
    behavior = "hidden"
    prerequisites = [ctfd_challenge.challenge1.id]
  }
  topics = ["topic1", "topic2"]
}

resource "ctfd_flag" "flag2" {
  challenge_id = ctfd_challenge.challenge2.id
  content = "someflag"
}
