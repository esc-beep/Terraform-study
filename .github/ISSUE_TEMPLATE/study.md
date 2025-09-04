name: 📖 Study Issue
description: Terraform 학습 또는 과제 기록용 이슈
title: "[Study] {주차/주제}"
labels: ["study"]
body:
  - type: input
    id: week
    attributes:
      label: 주차
      description: 몇 주차 학습인가요?
      placeholder: "예: Week 2 - Providers"
    validations:
      required: true
  - type: textarea
    id: summary
    attributes:
      label: 요약
      description: 학습한 내용을 간단히 정리해 주세요.
      placeholder: 주요 개념 및 배운 점
    validations:
      required: true
  - type: textarea
    id: challenges
    attributes:
      label: 어려웠던 점
      description: 이해가 잘 안 된 부분이나 토론이 필요한 주제를 적어주세요.
  - type: textarea
    id: next
    attributes:
      label: 다음 계획
      description: 다음에 학습할 계획이나 추가로 공부할 점이 있나요?
